class JobsController < ApplicationController
  before_filter :is_login?
  before_filter :access_role?
  
  before_filter :session_types, :except => ["index", "show"]
  before_filter :find_id_by_role, :only => ["new", "edit", "create", "update"]

  def index
    if params[:my_job] == 'all jobs'
      @jobs = search_by_session(current_login.jobs.search(params[:search])).order("created_at desc").paginate(:per_page => 10, :page => params[:page])
    elsif params[:my_job]== 'unassigned jobs'
      @jobs = search_by_session(current_login.jobs.search(params[:search]).where(:assigned_to => "NULL")).paginate(:per_page => 10, :page => params[:page])
    elsif params[:my_job] == 'my jobs'
      @jobs = search_by_session(current_login.jobs.search(params[:search]).where("status='open' AND assigned_to != 'NULL'")).paginate(:per_page => 10, :page => params[:page])
    elsif params[:my_job] == 'closed jobs'
      @jobs = search_by_session(current_login.jobs.search(params[:search]).where(:status => "closed")).paginate(:per_page => 10, :page => params[:page])
    else
      @jobs = search_by_session(current_login.jobs.search(params[:search])).order("created_at desc").paginate(:per_page => 10, :page => params[:page])
    end
    if request.xhr?
      respond_to do |format|
        format.js 
      end
    end
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @job = Job.new
  end

  def edit
    @job = Job.find(params[:id])
    @customer = Customer.find_by_id(@job.customer_id)
    @jobsite = Jobsite.find_by_id(@job.jobsite_id)
    session[:customer_id] = @job.customer_id
    session[:jobsite_id] = @job.jobsite_id
    session[:job_id] = @job.id
  end

  def create
    @job = Job.new(params[:job])
    @job.company_id = current_login.id
    

    @note = current_login.notes.new
    @notes = search_by_session_type("note",current_login.notes,"Job").order("created_at desc")
    if @job.save
      session_job_id
      if params[:select_action] == "print"
        redirect_to job_pdf_job_path(@job)
      elsif params[:select_action] == "email"
        @company = Company.find(current_login.id)
        CompanyMailer.send_job_details(@company,@job).deliver
        redirect_to jobs_path, :notice => "Job details are sent to company's email"
      else
        redirect_to jobs_path, :notice => 'Job was successfully created.'
      end
    else
      render :action => "new"
    end
  end

  def job_pdf
    @job = Job.find(params[:id])
    render :pdf => "jobs/job_pdf.html.erb"
  end

  def update
    @job = Job.find(params[:id])
    params[:job][:customer_id] = session[:customer_id]
    params[:job][:jobsite_id] = session[:jobsite_id]
    if @job.update_attributes(params[:job])
      session_job_id

      redirect_to jobs_path, :notice => "Job was successfully updated."
    else
      render :action => "edit"
    end
  end

  def destroy
    @job = Job.find(params[:id])
    if @job.destroy
      #destroy the session
      session[:job_id] = nil
      flash[:notice] =  "Job was successfully deleted."
    else
      flash[:error] =  "Job deletion failed."
    end
    redirect_to jobs_url
  end

  def session_job_id
    @job.id ? session[:job_id] = @job.id : ''
  end

  def find_id_by_role
    @tech_role = current_login.roles.find_by_roll("Tech")
    @tech_role ? @tech_users = current_login.users.find_all_by_role_id(@tech_role.id) : @tech_users = nil

    @sales_role = current_login.roles.find_by_roll("Sales")
    @sales_role ? @sales_users = current_login.users.find_all_by_role_id(@sales_role.id) : @sales_users = nil
  end

  def close_job
    @jobs = search_by_session(current_login.jobs.search(params[:search])).order("created_at desc").paginate(:per_page => 10, :page => params[:page])
    @job = Job.find(params[:id])
    @job.update_attribute(:status, "closed")
    respond_to do |format|
      format.js
    end
  end
end
