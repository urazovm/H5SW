class Custom < ActiveRecord::Base
  attr_accessible :field, :name, :company_id, :cus_type, :tab_id, :position, :status

  belongs_to :company
  belongs_to :tab

  validates :name, :presence => true
  validates :name, :uniqueness => {:scope => [:company_id, :cus_type, :tab_id], :message => "Custom field is already created"}
  
  has_many :dropdown_values, :dependent => :destroy
end
