class JobsController < ApplicationController

  before_filter :is_login?
  
  # GET /jobs
  def index
    @jobs = current_company.jobs.search(params[:search]).paginate(:per_page => 5, :page => params[:page])
  end

  # GET /jobs/1
  def show
    @job = Job.find(params[:id])
    @documents = @job.documents
    
    respond_to do |format|
      format.html
      format.json { render json: @job}
    end
  end

  # GET /jobs/new
  def new
    @job = Job.new
    @customer_id = session[:customer_id]
    @jobsite_id = session[:jobsite_id]

    

    @customer_id ? @customer = Customer.find(@customer_id) : nil
    @jobsite_id ? @jobsite = Jobsite.find(@jobsite_id) : nil
@note = current_company.notes.new
    @notes = current_company.notes.where("notable_type='Job'").order("created_at desc")
    @job_number = Job.count + 1
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end

  # POST /jobs
  def create
    @job = Job.new(params[:job])
    @job.job_number = Job.count + 1
    @job.company_id = current_company.id
    @note = current_company.notes.new
    @notes = current_company.notes.where("notable_type='Job'").order("created_at desc")
    #@job.customer_id = current_customer.id
    if @job.save
      if params[:select_action] == "print"
        redirect_to job_pdf_job_path(@job)
      elsif params[:select_action] == "email"
        @company = Company.find(current_company.id)
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

  # PUT /jobs/1
  def update
    @job = Job.find(params[:id])

    if @job.update_attributes(params[:job])
      redirect_to jobs_path(@job), :notice => "Job was successfully updated."
    else
      render :action => "edit"
    end
  end

  # DELETE /jobs/1
  def destroy
    @job = Job.find(params[:id])
    if @job.destroy
      flash[:notice] =  "Job was successfully deleted."
    else
      flash[:error] =  "Job deletion failed."
    end
    redirect_to jobs_url
  end
end
