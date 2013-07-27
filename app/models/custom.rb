class Custom < ActiveRecord::Base
  attr_accessible :field, :name, :company_id, :cus_type, :tab,:position
  belongs_to :company
  validates :name, :presence => true
  validates :cus_type, :presence => true
  validates :name, :uniqueness => {:scope => [:company_id, :cus_type], :message => "Custom field name is already created"}
  has_many :dropdown_values, :dependent => :destroy
end
