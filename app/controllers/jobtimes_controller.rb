class JobtimesController < ApplicationController
  before_filter :is_login?
  before_filter :session_types
  before_filter :find_users_by_role, :only => ["new", "create", "update", "edit"]

  def index
    #@jobtimes = current_login.jobtimes.paginate(:per_page =>10, :page => params[:page])
    @jobtimes = current_login.jobtimes.find_all_by_job_id(session[:job_id])
  end

  def new
    @jobtime = Jobtime.new
  end

  def create
    @start_time = params[:start_time].to_datetime.strftime("%Y-%m-%d %H:%M:%S")
    @end_time = params[:end_time].to_datetime.strftime("%Y-%m-%d %H:%M:%S")
    @service = params[:service]

    #@hours = ((@end_time.to_datetime-@start_time.to_datetime) * 24 ).to_i
    #@minutes = ((@end_time.to_datetime-@start_time.to_datetime) * 24 * 60 ).to_i
    #@seconds = ((@end_time.to_datetime-@start_time.to_datetime) * 24 * 60 * 60 ).to_i

    @hours = params[:hours]
    @minutes = params[:minutes]
    @seconds = params[:seconds]

    @quantity = @hours.to_s+':'+@minutes.to_s+':'+@seconds.to_s
    @jobtime = Jobtime.new(:start_time => @start_time, :end_time => @end_time,:qty => @quantity,:company_id => current_login.id,:job_id => session[:job_id],:jobsite_id => session[:jobsite_id],:customer_id => session[:customer_id],:user => current_login.name, :timetype => "Actual Time", :service => @service)
    if @jobtime.save(:validate => false)
      respond_to do |format|
        format.js
      end
    else
      render :action => "new"
    end
  end

  def jobtime_shedule
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

  def find_users_by_role
      @tech_users = User.joins("left join roles on roles.id = users.role_id").where("users.company_id='#{current_login.id}' and roles.jobtimes = 'Read-Write' OR roles.jobtimes = 'Read-Only'")
      @current_user = current_login.name
  end
end
