class JobsitesController < ApplicationController 
  before_filter :is_login?
  before_filter :gmap_json, :only => ["edit"]

  def index
    @jobsites = search_by_customer_id(Jobsite.search(params[:search])).order("created_at desc").paginate(:per_page => 10, :page => params[:page])
  end

  def new
    params[:cust_id] ? session[:customer_id] = params[:cust_id] : ''
    params[:cust_id] ? session[:jobsite_id] = nil : ''

    @jobsite = Jobsite.new
    session[:customer_id] ? @customer_id = session[:customer_id] : ''
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
end
