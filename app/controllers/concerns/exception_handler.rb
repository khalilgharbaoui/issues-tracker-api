# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ActionController::UnpermittedParameters, with: :unauthorized_request
    rescue_from Pundit::NotAuthorizedError, with: :unauthorized_request
    rescue_from ActiveRecord::RecordNotFound, with: :four_zero_four
    rescue_from ArgumentError, with: :four_zero_zero
    # rescue_from ActiveModel::StrictValidationFailed, with:  :four_zero_zero
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    json_response({ message: e.message }, :unauthorized)
  end

  # JSON response with message; Status code 400 - Bad Request
  def four_zero_zero(e)
    json_response({ message: e.message, assigned_to: "'#{current_user.id}', ''" }, :bad_request)
  end

  # JSON response with message; Status code 400 - Bad Request
  def four_zero_four(e)
    json_response({ message: e.message }, :not_found)
  end
end
