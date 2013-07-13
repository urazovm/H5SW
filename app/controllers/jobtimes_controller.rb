class JobtimesController < ApplicationController
  before_filter :is_login?
  before_filter :session_types

  def index
    @jobtimes = current_login.jobtimes.all
    @json = Customer.all.to_gmaps4rails
    @json = Jobsite.all.to_gmaps4rails
  end

  def new
    @jobtime = Jobtime.new
  end

  def create
    @start_time = params[:start_time].to_datetime.strftime("%Y-%m-%d %H:%M:%S")
    @end_time = params[:end_time].to_datetime.strftime("%Y-%m-%d %H:%M:%S")
    @hours = ((@end_time.to_datetime-@start_time.to_datetime) * 24 ).to_i
    @minutes = ((@end_time.to_datetime-@start_time.to_datetime) * 24 * 60 ).to_i
    @seconds = ((@end_time.to_datetime-@start_time.to_datetime) * 24 * 60 * 60 ).to_i
    @quantity = @hours.to_s+':'+@minutes.to_s+':'+@seconds.to_s
    @jobtime = Jobtime.new(:start_time => @start_time,:end_time => @end_time,:qty => @quantity,:company_id => current_login.id,:job_id => session[:job_id],:jobsite_id => session[:jobsite_id],:customer_id => session[:customer_id],:user => current_login.name)
    if @jobtime.save
      respond_to do |format|
        format.js
      end
    else
      render :action => "new"
    end
  end
  

  def edit
    @jobtime = Jobtime.find(params[:id])
  end

  def update
    @jobtime = Jobtime.find(params[:id])
    if @jobtime.update_attributes(params[:jobtime])
      flash[:notice] = "time was successfully updated."
      redirect_to jobtimes_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @jobtime = Jobtime.find(params[:id])
    if @jobtime.destroy
      redirect_to jobtime_url
    end
  end
end
