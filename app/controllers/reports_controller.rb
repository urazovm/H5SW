class ReportsController < ApplicationController
   def index
    @jobs = current_login.jobs.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @job = Job.find(params[:id])
  end
  
  def send_mail
    @job = Job.find(params[:id])
    @company = Company.find(current_login.id)
    CompanyMailer.send_job_report(@company,@job).deliver
    respond_to do |format|
      format.js
    end
  end
  
  def job_report
    @job = Job.find(params[:id])
    render :pdf => "reports/job_report.html.erb"
    respond_to do |format|
      format.js
    end
  end
end
