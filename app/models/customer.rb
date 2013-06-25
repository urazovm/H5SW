
class Customer < ActiveRecord::Base

  attr_accessible :company_id, :action,:types, :company_name, :parent_billing, :address1, :address2, :city, :state, :zip, :contact, :website, :business_type, :terms_client, :status, :account, :phone, :contact_id

   
  belongs_to :company
  has_many :jobs
  has_many :contacts
  has_many :jobsites
  
  has_many :documents, :as => :documentable
  has_many :notes, :as => :notable

  has_many :items

  validates:company_name,:address1, :address2, :city, :state, :zip,:website, :business_type, :account, :status ,:presence => true
  validates :account, :uniqueness => true
  validates :phone, :presence =>true,:numericality => {:only_integer => true }
  def self.search(search)
    if search
      where('company_name LIKE?', "%#{search}%")
    else
      scoped
    end
  end
end
