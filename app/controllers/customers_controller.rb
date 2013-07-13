class CustomersController < ApplicationController
  before_filter :is_login?
  before_filter :access_role?

  # GET /customers
  def index
    @customers = current_login.customers.search(params[:search]).paginate(:per_page => 10, :page => params[:page])
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
    @json = Customer.all.to_gmaps4rails
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
end
