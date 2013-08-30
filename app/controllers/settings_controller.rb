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
      current_company.update_attributes({
          :access_token => access_token,
          :access_secret => access_secret,
          :realm_id => realm_id
        })
    end
    
    render 
  end
  
  def dis_quickbooks
    if signed_in?
      current_company.update_attributes({
          :access_token => nil,
          :access_secret => nil,
          :realm_id => nil
        })
      redirect_to accounting_settings_path
    end
  end
  
  def bluedot
    
  end

  # sync all customer from quickbook to SMO and vice versa
  def sync_customer_data
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_company.access_token, current_company.access_secret)

    customer_service = Quickeebooks::Online::Service::Customer.new
    customer_service.access_token = oauth_client
    customer_service.realm_id = current_company.realm_id

    #load all the customers created in quickbooks
    @customers =	customer_service.list.entries

    #check the condition for each customer either they exists in our application or not
    #if any of the customer doesnot exists in our application then create new customer
    #with quickbook customer values
    @customers.each do |customer|
      unless current_company.customers.exists?(:quickbook_customer_id => customer.id.to_i)
        current_company.customers.create(:types => "Customer", :account => " ", :company_name => customer.name, :address1 => customer.addresses.present? ? customer.addresses.first.line1 : "", :address2 => customer.addresses.present? ? customer.addresses.first.line2 : "", :city => customer.addresses.present? ? customer.addresses.first.city : "", :state => customer.addresses.present? ? customer.addresses.first.country_sub_division_code : "", :zip => customer.addresses.present? ? customer.addresses.first.postal_code : "", :phone => customer.phones.present? ? customer.phones.first.free_form_number : "", :website => customer.web_site.present? ? customer.web_site.uri : "", :quickbook_customer_id => customer.id)
      end
    end

    # push non-existing customers to QBO from SMO
    qbo_customers = []
    smo_customers = []
    non_matching_customers = []

    qbo_customers = @customers.map{|c| [c.name]}
    smo_customers = current_company.customers.where("types!=?", "Prospect").map{|c| [c.company_name]}

    non_matching_customers = smo_customers - qbo_customers # non matching in SMO, push these to quickbook

    non_matching_customers.each do |customer|
      smo_customers = current_company.customers.find_by_company_name(customer)
      push_to_quickbook(smo_customers)
    end
  end

  # push SMO_customer_to_quickbook
  def push_to_quickbook(customers)
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_company.access_token, current_company.access_secret)

    customer_service = Quickeebooks::Online::Service::Customer.new
    customer_service.access_token = oauth_client
    customer_service.realm_id = current_company.realm_id

    @customer = customers
    
    customer = Quickeebooks::Online::Model::Customer.new

    customer.name = @customer.company_name
    #customer.email = Quickeebooks::Online::Model::Email.new(@customer.email)

    address = Quickeebooks::Online::Model::Address.new
    address.line1 = @customer.address1
    address.line2 = @customer.address2
    address.city = @customer.city
    address.country_sub_division_code = @customer.state
    address.postal_code = @customer.zip
    customer.addresses = [address]

    phone1 = Quickeebooks::Online::Model::Phone.new
    phone1.device_type = "Primary"
    phone1.free_form_number = (@customer.phone.present? ? @customer.phone : "-")
    phone2 = Quickeebooks::Online::Model::Phone.new
    phone2.device_type = "Mobile"
    phone2.free_form_number = (@customer.phone.present? ? @customer.phone : "-")
    customer.phones = [phone1, phone2]

    website = Quickeebooks::Online::Model::WebSite.new
    website.uri = @customer.website
    customer.web_site = website

    #create customer with these datas
    customer_service.create(customer)

    filters = []
    filters << Quickeebooks::Online::Service::Filter.new(:text, :field => 'name', :value => customer.name)
    customer = customer_service.list(filters)
    @customer = current_company.customers.find(@customer.id)
    quickbook_customer_id = customer.entries.first.id

    #update quickbook_customer_id field in customer table
    @customer.update_attributes(:quickbook_customer_id => quickbook_customer_id)
  end


  

  # sync all items from quickbook
  def sync_items
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_company.access_token, current_company.access_secret)

    item_service = Quickeebooks::Online::Service::Item.new
    item_service.access_token = oauth_client
    item_service.realm_id = current_company.realm_id

    #load all the customers created in quickbooks
    @items =	item_service.list.entries

    @items.each do |item|
      if !current_company.items.exists?(:name => item.name)
        current_company.items.create(:quickbook_item_id => item.id, :name => item.name, :description => item.desc, :unit_price => item.unit_price.present? ? item.unit_price.amount : 0, :unit_cost => 0, :itemtype => "-", :qty => 1, :number => "-")
      else
        @item = current_company.items.find_by_name(item.name)
        @item.update_attributes(:quickbook_item_id => item.id, :name => item.name, :description => item.desc, :unit_price => item.unit_price.present? ? item.unit_price.amount : 0, :unit_cost => 0, :itemtype => "-", :qty => 1, :number => "-")
      end
    end
  end



  def sync_employees
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_company.access_token, current_company.access_secret)

    user_service = Quickeebooks::Online::Service::Employee.new
    user_service.access_token = oauth_client
    user_service.realm_id = current_company.realm_id

    # find sub-contractor role
    @role_id = current_company.roles.find_by_roll("Tech").id if current_company.roles.exists?(:roll => "Tech")

    # load all the employees
    @employees = user_service.list.entries

    # check for existing value
    @employees.each do |employee|
      unless current_company.users.exists?(:name => employee.name, :role_id => @role_id)
        #email = (employee.email.present? ? employee.email.address : "#{SecureRandom.urlsafe_base64 + "@gmail.com"}")
        email = employee.email.present? ? employee.email.address : "-"
        @user = current_company.users.new(:password => "qawsed!@#", :password_confirmation => "qawsed!@#", :role_id => @role_id, :name => employee.name, :accounting_name => employee.name, :email => email, :smo_user => false, :language => "English", :company_id => current_company.id, :time_zone => "Hawaii", :accounting_type => "Employee")
        @user.save(:validate => false)
      end
    end
  end



  def sync_vendors
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_login.access_token, current_login.access_secret)

    vendor_service = Quickeebooks::Online::Service::Vendor.new
    vendor_service.access_token = oauth_client
    vendor_service.realm_id = current_login.realm_id

    # find sub-contractor role
    @role_id = current_login.roles.find_by_roll("Subcontractor").id if current_login.roles.exists?(:roll => "Subcontractor")

    # load all the employees
    @vendors = vendor_service.list.entries

    # check for existing value
    @vendors.each do |vendor|
      unless current_login.users.exists?(:name => vendor.name, :role_id => @role_id)
        #email = (vendor.email.present? ? vendor.email.address : "#{SecureRandom.urlsafe_base64 + "@gmail.com"}") # if email present
        email = vendor.email.present? ? vendor.email.address : "-"
        @user = current_login.users.new(:password => "qawsed!@#", :password_confirmation => "qawsed!@#", :role_id => @role_id, :name => vendor.name, :accounting_name => vendor.name, :email => email, :smo_user => false, :language => "English", :company_id => current_login.id, :time_zone => "Hawaii", :accounting_type => "Vendor")
        @user.save(:validate => false)
      end
    end
  end



  def sync_salse_person
    # sync Rep
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_login.access_token, current_login.access_secret)

    rep_service = Quickeebooks::Online::Service::Rep.new
    rep_service.access_token = oauth_client
    rep_service.realm_id = current_login.realm_id

    # find sub-contractor role
    @role_id = current_login.roles.find_by_roll("Sales").id if current_login.roles.exists?(:roll => "Sales")

    # load all the employees
    @sales_persons = user_service.list.entries

    # check for existing value
    @sales_persons.each do |sales_person|
      unless current_login.users.exists?(:name => sales_person.name, :role_id => @role_id)
        email = (sales_person.email.present? ? sales_person.email.address : "#{SecureRandom.urlsafe_base64 + "@gmail.com"}")
        current_login.users.new(:password => "qawsed!@#", :password_confirmation => "qawsed!@#", :role_id => @role_id, :name => sales_person.name,
          :accounting_name => sales_person.name, :email => email, :smo_user => false, :language => "English",
          :company_id => current_login.id, :time_zone => "Hawaii", :accounting_type => "Customer")
      end
    end
  end
end
