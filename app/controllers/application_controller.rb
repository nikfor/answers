require "application_responder"

class ApplicationController < ActionController::Base

  skip_authorization_check if: :devise_controller?

  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { errors: exception.message[:text], id: exception.message[:id] }, status: :forbidden }
      format.js do
        flash[:notice] = exception.message
        render 'access_errors', status: :forbidden
      end
    end
  end

  check_authorization
end
