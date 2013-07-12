class Company < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :phone_number
  validates :name, :presence => true, :uniqueness => true
  validates :phone_number, :presence =>true,:numericality => {:only_integer => true, :message => "Please Enter Valid Phone Number" }

  has_many :customers
  has_many :jobs
  has_many :contacts
  has_many :notes
  has_many :documents
  has_many :users, :dependent => :destroy
  has_many :roles, :dependent => :destroy
  has_many :items
  has_many :customs
  has_many :inventories
end
