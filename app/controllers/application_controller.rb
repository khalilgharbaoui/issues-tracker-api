class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include Pundit
  attr_reader :current_user
  # called before every action on controllers
  before_action :authorize_request
  after_action :verify_authorized
  private

  # Check for valid request token and return user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end
end
