class CompanyMailer < ActionMailer::Base
  default :from => "info@smo.com"

  def send_job_details(company,job)
    @company = company
    @date_and_time = Time.now
    @job = job
    mail(:to => @company.email, :subject => "Job details")
  end

  def user_link(user,company)
    @user = user
    @company = company
    mail(:to => @user.email,:subject => "Company #{@company.name} created you")
  end
end
