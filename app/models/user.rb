class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :role_id, :name, :accounting_type, :accounting_name, :email, :password, :password_confirmation, :remember_me, :smo_user, :language, :time_zone,:confirmation_token, :confirmed_at, :reset_password_token, :reset_password_sent_at

  validates :role_id, :name, :accounting_type, :accounting_name, :email, :smo_user, :language, :time_zone, :presence => true
  belongs_to :role
  belongs_to :company
end
