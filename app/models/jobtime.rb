class Jobtime < ActiveRecord::Base
   attr_accessible :timetype, :qty, :user, :service, :job_id, :jobsite_id, :customer_id, :company_id, :start_time, :end_time, :billable, :cost, :price
   belongs_to :job
   belongs_to :company
   belongs_to :customer
   belongs_to :jobsite

   validates :job_id, :presence => true
   validates :customer_id, :presence => true
   validates :qty, :presence => true, :numericality => {:only_integer => true}
end
