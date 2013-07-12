class Custom < ActiveRecord::Base
  attr_accessible :field, :name, :company_id, :type
  belongs_to :company
  validates :name, :presence => true
  validates :type, :presence => true
  has_many :dropdown_values,:dependent => :destroy
end
