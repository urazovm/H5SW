class CustomersController < ApplicationController
  before_filter :is_login?
  before_filter :access_role?
  #before_filter :gmap_json, :only => ["edit"]

  # GET /customers
  def index
    @customers = current_login.customers.search(params[:search]).order("created_at desc").paginate(:per_page => 10, :page => params[:page])
    #@customers = current_login.customers.paginate :per_page => 10, :page => params[:page], :joins => :contacts, :conditions => ['customers.company_name ILIKE ? OR customers.types ILIKE ? OR contacts.name ILIKE ? OR contacts.email ILIKE?',"%#{params[:search]}%", "%#{params[:search]}%","%#{params[:search]}%", "%#{params[:search]}%" ], :order => 'customers.id'
  end
  # GET /customers/1
  def show
    @customer = Customer.find(params[:id])
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    @jobsites = Jobsite.all.find(params[:customer_id]) 
 	end

  # GET /customers/1/edit
  def edit
    session[:customer_id] = params[:id]
    @customer = Customer.find(session[:customer_id])
    @customer_old_name = @customer.company_name #required to find records from quickbook and for updation
  end

  # POST /customers
  def create
    @customer = Customer.new(params[:customer])
    @customer.company_id = current_login.id

    @phone1 = params[:customer][:phone1]
    @phone2 = params[:customer][:phone2]
    @phone3 = params[:customer][:phone3]
    @phone4 = params[:customer][:phone4]
    if @customer.save
      push_to_quickbook(@customer)
      flash[:notice] = "Customer was successfully created."
      redirect_to customers_path
    else
      render :action => "new"
    end
  end

  # PUT /customers/1
  def update
    @customer = Customer.find(params[:id])
    @phone1 = params[:customer][:phone1]
    @phone2 = params[:customer][:phone2]
    @phone3 = params[:customer][:phone3]
    @phone4 = params[:customer][:phone4]

    if @customer.update_attributes(params[:customer])
      
      update_to_quickbooks(@customer)   #update in quickbooks also

      flash[:notice] = "Customer was successfully updated."
      redirect_to customers_path
    else
      render :action => "edit"
    end
  end

  # DELETE /customers/1
  def destroy
    @customer = Customer.find(params[:id])
    if @customer.destroy
      flash[:notice] = "Customer was successfully deleted."
    else
      flash[:error] = "Customer deletion is failed. please try again."
    end
    redirect_to customers_url
  end

  #push into quickbook
  def push_to_quickbook(customers)
    #push data to quickbook
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_login.access_token, current_login.access_secret)

    #creating customer in quickbooks
    customer_service = Quickeebooks::Online::Service::Customer.new
    customer_service.access_token = oauth_client
    customer_service.realm_id = current_login.realm_id
    customer_service.list

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
    phone1.free_form_number = @customer.phone
    phone2 = Quickeebooks::Online::Model::Phone.new
    phone2.device_type = "Mobile"
    phone2.free_form_number = @customer.phone 
    customer.phones = [phone1, phone2]

    website = Quickeebooks::Online::Model::WebSite.new
    website.uri = @customer.website
    customer.web_site = website

    #create customer with these datas
    customer_service.create(customer)
    
    filters = []
    filters << Quickeebooks::Online::Service::Filter.new(:text, :field => 'name', :value => customer.name)
    customer = customer_service.list(filters)
    @customer = current_login.customers.find(@customer.id)
    quickbook_customer_id = customer.entries.first.id

    #update quickbook_customer_id field in customer table
    @customer.update_attributes(:quickbook_customer_id => quickbook_customer_id)
  end

  def update_to_quickbooks(customers)
    #push data to quickbook
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_login.access_token, current_login.access_secret)

    #creating customer in quickbooks
    customer_service = Quickeebooks::Online::Service::Customer.new
    customer_service.access_token = oauth_client
    customer_service.realm_id = current_login.realm_id
    customer_service.list

#    filter customer with old customer_name
#    filters = []
#    filters << Quickeebooks::Online::Service::Filter.new(:text, :field => 'name', :value => params[:customer_name])
#    customer = customer_service.list(filters)
#    customer = customer.entries.first

    customer = customer_service.fetch_by_id(@customer.quickbook_customer_id)

    # update old values to new value here
    customer.name = @customer.company_name
    
    #update addresses
    customer.addresses.first.line1 = @customer.address1
    customer.addresses.first.line2 = @customer.address2
    customer.addresses.first.city = @customer.city
    customer.addresses.first.country_sub_division_code = @customer.state
    customer.addresses.first.postal_code = @customer.zip

    #update phones
    customer.phones.first.free_form_number = customer.phones.second.free_form_number = @customer.phone

    #update website uri
    customer.web_site.uri = @customer.website

    customer_service.update(customer)
  end
end
