class CustomersController < ApplicationController
  before_filter :is_login?
  before_filter :access_role?
  before_filter :gmap_json, :only => ["edit"]

  # GET /customers
  def index
    @customers = current_login.customers.search(params[:search]).order("created_at desc").paginate(:per_page => 10, :page => params[:page])
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
      push_to_quickbook(@customer, "create")
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
  def push_to_quickbook(customers, action)
    #push data to quickbook
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_login.access_token, current_login.access_secret)

    #creating customer in quickbooks
    customer_service = Quickeebooks::Online::Service::Customer.new
    customer_service.access_token = oauth_client
    customer_service.realm_id = current_login.realm_id
    customer_service.list

    #check whether to create new or update existing customer
    if action=="create"
      customer = Quickeebooks::Online::Model::Customer.new
    else
      customer = customer_service.fetch_by_id(params[:id])
    end

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

    if action == "create"
      customer_service.create(customer)
    elsif action == "update"
      customer_service.update(customer)
    end
  end
end
