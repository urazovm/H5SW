class Contact < ActiveRecord::Base
  attr_accessible :business, :email, :mobile, :name, :role, :twitter, :company_id, :jobsite_id, :customer_id

  belongs_to :company

  validates :business, :email, :mobile, :name, :role, :twitter, :presence => true
  validates :name, :twitter, :email, :uniqueness => true
  validates_numericality_of :mobile, :presence => true, :only_integer => true
  validates :customer_id, :jobsite_id, :presence => true

  def self.search(search)
    if search
      where('name LIKE?', "%#{search}%")
    else
      scoped
    end
  end
  
end
