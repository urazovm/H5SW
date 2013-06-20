class CompanyMailer < ActionMailer::Base
  default :from => "info@smo.com"

  def send_job_details(company,job)
    @company = company
    @date_and_time = Time.now
    @job = job
    mail(:to => @company.email, :subject => "Job details")
  end
end
