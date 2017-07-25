class Api::V1::BaseController < Api::BaseController
  rescue_from ActiveRecord::RecordNotFound,
              ActionController::RoutingError,
              ActiveRecord::RecordInvalid,
              with: :respond_with_404

  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    message = "#{parameter_missing_exception.param}: parameter is missing or incorrect"
    error = Api::V1::ErrorService::MessageMapper.params_error(message)
    render json: error, serializer: Api::V1::ErrorSerializer, root: 'errors', status: :unprocessable_entity
  end

  rescue_from Api::V1::ErrorService::ApplicationError, with: :render_application_error

  protected

  def render_application_error(exception)
    render_error Api::V1::ErrorService.handle(exception)
  end

  def render_error(error)
    render json: error, root: 'errors', serializer: Api::V1::ErrorSerializer, status: error.status
  end

  def respond_with_404
    error = Api::V1::ErrorService::MessageMapper.not_found
    render json: error, root: 'errors', serializer: Api::V1::ErrorSerializer, status: :not_found
  end
end
