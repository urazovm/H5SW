class JobtimesController < ApplicationController
  before_filter :is_login?
  before_filter :session_types
  before_filter :gmap_json, :only => ["index"]
  before_filter :find_id_by_role, :only => ["new", "create", "update", "edit"]

  def index
    @jobtimes = current_login.jobtimes.all
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
    @jobtime = Jobtime.new(:start_time => @start_time, :end_time => @end_time,:qty => @quantity,:company_id => current_login.id,:job_id => session[:job_id],:jobsite_id => session[:jobsite_id],:customer_id => session[:customer_id],:user => current_login.name, :timetype => "Actual Time")
    if @jobtime.save(:validate => false)
      respond_to do |format|
        format.js
      end
    else
      render :action => "new"
    end
  end

  def shedule
    @jobtime = Jobtime.new(params[:jobtime])

    @qty = @jobtime.qty.to_i.hours
    @item = Item.find(@jobtime.service)

    #calculate end_time
    @jobtime.end_time = @jobtime.start_time+@qty

    #calculate cost
    @jobtime.cost = @item.unit_cost * @qty

    #calculate price
    if(@jobtime.billable.present?)
      @jobtime.price = @item.unit_price * @qty
    else
      @jobtime.price = 0
    end

    if @jobtime.save
      redirect_to jobtimes_path
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

  def find_id_by_role
    @tech_role = current_login.roles.find_by_roll("Tech")
    @tech_role ? @tech_users = current_login.users.find_all_by_role_id(@tech_role.id) : @tech_users = nil
  end
end
