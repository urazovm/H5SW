class Jobsite < ActiveRecord::Base
  attr_accessible :name, :city, :state, :zip, :customer_id
  belongs_to :customer
  has_many :documents
  has_many :notes
  has_many :items
  has_many :jobtimes
  validates :name, :city, :state, :zip, :customer, :presence => true

  def self.search(search)
    if search
      where('name LIKE?', "%#{search}%")
    else
      scoped
    end
  end

  acts_as_gmappable

  def gmaps4rails_address
  "#{self.city}, #{self.state}, #{self.zip}"
  end
  
end
