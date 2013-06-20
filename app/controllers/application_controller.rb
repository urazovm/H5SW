class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all

  def after_sign_in_path_for(resource_or_scope)
    root_path
  end

  def after_sign_up_path_for(resource_or_scope)
    after_sign_in_path_for(resource_or_scope)
  end

  def is_login?
    unless current_company
      flash[:error] = "Please login"
      redirect_to '/'
    end
  end

  
end
