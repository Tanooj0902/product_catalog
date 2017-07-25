# frozen_string_literal: true

class Api::V1::ErrorSerializer < ActiveModel::Serializer
  attributes :code, :message

  def code
    if object.respond_to?(:each)
      object.map(&:code).uniq.join(',')
    else
      object.code
    end
  end

  def message
    if object.respond_to?(:each)
      object.map(&:message).uniq.join(',')
    else
      object.message
    end
  end
end
