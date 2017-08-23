class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  layout :layout_by_resource  # if logout it should render landing, instead of applicaton.html.erb

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname, :title])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:firstname, :lastname, :title])

  end

  def after_sign_in_path_for(resource)
    admin_cases_path
  end


private
def layout_by_resource
  "landing" if devise_controller?
end
end
