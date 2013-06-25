class Jobsite < ActiveRecord::Base
  attr_accessible :name, :city, :state, :zip, :customer_id
  belongs_to :customer
  has_many :documents
  has_many :notes
  has_many :items
  validates :name, :city, :state, :zip, :customer, :presence => true
end
