class Contact < ActiveRecord::Base
  attr_accessible :business, :email, :mobile, :name, :role, :twitter, :company_id

  belongs_to :company

  validates :business, :email, :mobile, :name, :role, :twitter, :presence => true
  validates :name, :twitter, :uniqueness => true
  validates_numericality_of :mobile, :presence => true, :only_integer => true

  def self.search(search)
    if search
      where('name LIKE?', "%#{search}%")
    else
      scoped
    end
  end
  
end
