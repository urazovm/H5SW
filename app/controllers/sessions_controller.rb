class SessionsController < Devise::SessionsController
  def destroy
    signed_in = signed_in?(resource_name)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    flash[:notice] = "Logout Sucessfully."
    redirect_to "/"
  end
end
