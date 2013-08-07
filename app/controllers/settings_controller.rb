class SettingsController < ApplicationController
   before_filter :is_login?
  before_filter :access_role?
  def index
  end
  
  def accounting
    
  end
  
  def authenticate
    callback = oauth_callback_settings_url
    token = $qb_oauth_consumer.get_request_token(:oauth_callback => callback)
    session[:qb_request_token] = token
    redirect_to("https://appcenter.intuit.com/Connect/Begin?oauth_token=#{token.token}")
  end
  
  def oauth_callback
    at = session[:qb_request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
    access_token = at.token
    access_secret = at.secret
    realm_id = params['realmId']
    
    if signed_in?
      current_login.update_attributes({
          :access_token => access_token,
          :access_secret => access_secret,
          :realm_id => realm_id
        })
    end
    
    render 
  end
  
  def dis_quickbooks
    if signed_in?
      current_login.update_attributes({
          :access_token => " ",
          :access_secret => " ",
          :realm_id => " "
        })
      redirect_to accounting_settings_path
    end
  end
  
  def bluedot
    
  end
end
