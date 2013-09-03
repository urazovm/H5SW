class JobsitesController < ApplicationController 
  before_filter :is_login?
  before_filter :gmap_json, :only => ["edit"]

  def index
    @jobsites = search_by_customer_id(Jobsite.search(params[:search])).order("created_at desc").paginate(:per_page => 10, :page => params[:page])
  end

  def new
    params[:cust_id] ? session[:customer_id] = params[:cust_id] : ' '
    params[:cust_id] ? session[:jobsite_id] = nil : ' '

    @jobsite = Jobsite.new
    session[:customer_id] ? @customer_id = session[:customer_id] : ' '
  end


  def show
    @jobsite = Jobsite.find(params[:id])
  end


  def edit
    @jobsite = Jobsite.find(params[:id])
  end

  def create
    
    @jobsite = Jobsite.new(params[:jobsite])
    
    if @jobsite.save
      #push_jobsite_to_quickbook(@jobsite)
      flash[:notice] = "Jobsite was successfully created."
      redirect_to jobsites_path
    else
      render :action => "new"
    end
  end

  # PUT /customers/1
  def update
    @jobsite = Jobsite.find(params[:id])
    if @jobsite.update_attributes(params[:jobsite])
      #update_to_quickbook(@jobsite)
      flash[:notice] = "Jobsite was successfully updated."
      redirect_to jobsites_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @jobsite = Jobsite.find(params[:jobsite])
    if @jobsite.destroy
      flash[:notice] = "Jobsite was successfully deleted"
    else
      flash[:error] = "Jobsite deletion failed"
    end
    redirect_to jobsites_url
  end

  # action for displaying dynamic select options
  def ajax_show
    session[:customer_id] = params[:id]
    session[:jobsite_id] = "All"
    @jobsites = Jobsite.find_all_by_customer_id(session[:customer_id])
    @edit = params[:edit]
    render
  end

  #action for storing the selected id to session
  def get_id
    session[:jobsite_id] = params[:id]
    render :nothing => true
  end


  def show_jobsite
    session[:customer_id] = params[:id]
    session[:jobsite_id] = "All"
    @customer = Customer.find(session[:customer_id])
    @jobsites = Jobsite.find_all_by_customer_id(session[:customer_id])
  end

 

  def get_jobsite
    @customer = Customer.find_by_id(session[:customer_id])
    session[:jobsite_id] = params[:id]
    @jobsite = Jobsite.find_by_id(session[:jobsite_id])
    respond_to do |format|
      format.js
    end
  end


  #push jobsite into quickbook as job
  def push_jobsite_to_quickbook(jobsites)
    #push data to quickbook
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_login.access_token, current_login.access_secret)

    jobsite_service = Quickeebooks::Online::Service::Job.new
    jobsite_service.access_token = oauth_client
    jobsite_service.realm_id = current_login.realm_id
    #jobsite_service.list
    
    jobsite = Quickeebooks::Online::Model::Job.new

    # find quickbook_customer_id
    @parent_customer = current_login.customers.find(@jobsite.customer_id)
    
    # parent customer information
    jobsite.customer_id = @parent_customer.quickbook_customer_id
    jobsite.customer_name = @parent_customer.company_name
    # end of parent customer information

    jobsite.name = @jobsite.name

    address = Quickeebooks::Online::Model::Address.new
    address.city = @jobsite.city
    address.country_sub_division_code = @jobsite.state
    address.postal_code = @jobsite.zip
    jobsite.addresses = [address]

    jobsite_service.create(jobsite)
  end

  def update_jobsite_to_quickbook(jobsite)

  end
end



