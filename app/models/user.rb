class User < ActiveRecord::Base
  attr_accessible :role_id, :name, :accounting_type, :accounting_name, :email, :smo_user, :language, :time_zone

  validates :role_id, :name, :accounting_type, :accounting_name, :email, :smo_user, :language, :time_zone, :presence => true
  belongs_to :role
  belongs_to :company
end
