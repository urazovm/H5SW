class Item < ActiveRecord::Base
  attr_accessible :itemtype, :qty, :number, :name, :description, :unit_cost, :unit_price, :job_item, :job_id, :company_id, :customer_id, :jobsite_id
   belongs_to :company
   belongs_to :customer
   belongs_to :job
   belongs_to :jobsite
   has_many :inventory

   validates :name, :presence => true, :uniqueness => true
   
end
