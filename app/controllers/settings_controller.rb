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
          :access_token => nil,
          :access_secret => nil,
          :realm_id => nil
        })
      redirect_to accounting_settings_path
    end
  end
  
  def bluedot
    
  end

  def sync_customer_data
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_login.access_token, current_login.access_secret)

    customer_service = Quickeebooks::Online::Service::Customer.new
    customer_service.access_token = oauth_client
    customer_service.realm_id = current_login.realm_id

    #load all the customers created in quickbooks
    @customers =	customer_service.list.entries

    #check the condition for each customer either they exists in our application or not
    #if any of the customer doesnot exists in our application then create new customer
    #with quickbook customer values
    @customers.each do |customer|
      if !current_login.customers.exists?(:quickbook_customer_id => customer.id.to_i)
        current_login.customers.create(:account => " ", :company_name => customer.name, :address1 => customer.addresses.present? ? customer.addresses.first.line1 : "", :address2 => customer.addresses.present? ? customer.addresses.first.line2 : "", :city => customer.addresses.present? ? customer.addresses.first.city : "", :state => customer.addresses.present? ? customer.addresses.first.country_sub_division_code : "", :zip => customer.addresses.present? ? customer.addresses.first.postal_code : "", :phone => customer.phones.present? ? customer.phones.first.free_form_number : "", :website => customer.web_site.present? ? customer.web_site.uri : "", :quickbook_customer_id => customer.id)
      end
    end
  end
  
  def sync_items
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_login.access_token, current_login.access_secret)

    item_service = Quickeebooks::Online::Service::Item.new
    item_service.access_token = oauth_client
    item_service.realm_id = current_login.realm_id

    #load all the customers created in quickbooks
    @items =	item_service.list.entries

    #check the condition for each customer either they exists in our application or not
    #if any of the customer doesnot exists in our application then create new customer
    #with quickbook customer values
    @items.each do |item|
      if !current_login.items.exists?(:name => item.name)
        current_login.items.create(:name => item.name, :description => item.desc, :unit_price => item, :itemtype => "")
      end
    end
  end

  def sync_items
    
  end
end
