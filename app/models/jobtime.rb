class Jobtime < ActiveRecord::Base
   attr_accessible :timetype, :qty, :user,:service, :jobdate, :job_id, :jobsite_id, :customer_id, :company_id,:start_time,:end_time
   belongs_to :job
   belongs_to :company
   belongs_to :customer
   belongs_to :jobsite
end
