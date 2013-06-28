class Contact < ActiveRecord::Base
  attr_accessible :business, :email, :mobile, :name, :role, :twitter, :company_id, :jobsite_id, :customer_id

  belongs_to :company

  validates :name,  :presence => true
  validates :email, :uniqueness => true
  validates :customer_id, :presence => true

   def self.search(search)
    if search
      where('name LIKE?', "%#{search}%")
    else
      scoped
    end
  end
  
end
