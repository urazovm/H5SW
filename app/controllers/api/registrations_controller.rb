class Api::RegistrationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  #create company using api call
  # curl -X POST -d 'company[name]=smo&company[phone_number]=8845786963&company[email]=h5sw@gmail[password]=123123123&company[password_confirmation]=123123123' http://localhost:3000/api/sign_up.json
   def create
    company = Company.new(params[:company])
    if company.save
      render :json=> company.as_json(:auth_token=>company.authentication_token, :email=>company.email), :status=>201
      return
    else
      warden.custom_failure!
      render :json=> company.errors, :status=>422
    end
  end

end
