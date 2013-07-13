class Custom < ActiveRecord::Base
  attr_accessible :field, :name, :company_id, :type
  belongs_to :company
  validates :name, :presence => true
  validates :type, :presence => true
  validates :name, :uniqueness => {:scope => [:company_id, :type], :message => "Custom field name is already created"}
  has_many :dropdown_values,:dependent => :destroy
end
