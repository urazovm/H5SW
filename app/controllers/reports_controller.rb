class ReportsController < ApplicationController
   def index
    @jobs = current_login.jobs.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @job = Job.find(params[:id])
  end
end
