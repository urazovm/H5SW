class Jobsite < ActiveRecord::Base
  attr_accessible :name, :city, :state, :zip, :customer_id
  belongs_to :customer
end
