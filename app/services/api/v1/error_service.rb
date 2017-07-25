# frozen_string_literal: true

module Api
  module V1
    module ErrorService
      def self.handle(error)
        Api::V1::ErrorService::MessageMapper.send(error.class.name.demodulize.underscore, error)
      end

      class ApplicationError < StandardError
        attr_reader :message, :instance, :klass

        def initialize(payload = {})
          @message = payload[:message]
          @instance = payload[:instance]
          @klass = payload[:klass]
        end

        def instance_errors
          return unless instance.present?
          instance.errors.messages.each_with_object({}) do |(attribute, messages), result|
            result[attribute] = messages.to_sentence
            result
          end.to_json
        end
      end

      class RecordInvalidError < ApplicationError; end
      class RecordNotFoundError < ApplicationError; end

      class MessageMapper < ActiveModelSerializers::Model
        attr_accessor :code, :message, :status

        def self.message_provider(key, interpolation_args = {})
          I18n.t "api.errors.#{key}", interpolation_args.delete_if { |_k, v| v.nil? }
        end

        Api::V1::ErrorService::ApplicationError.descendants.each do |application_error_class|
          error_class = application_error_class.name.demodulize.underscore

          define_singleton_method error_class do |error|
            new code: message_provider("#{error_class}.code"),
                message: message_provider("#{error_class}.message",
                                          message: error.message,
                                          instance_errors: error.instance_errors,
                                          klass: error.klass),
                status: message_provider("#{error_class}.status")
          end
        end

        def self.params_error(message)
          new code: message_provider('params_error.code'),
              message: message_provider('params_error.message', message: message),
              status: message_provider('params_error.status')
        end

        def self.not_found
          new code: message_provider('not_found_error.code'),
              message: message_provider('not_found_error.message'),
              status: message_provider('not_found_error.status')
        end
      end
    end
  end
end
