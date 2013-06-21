class Contact < ActiveRecord::Base
  attr_accessible :business, :email, :mobile, :name, :role, :twitter, :company_id, :jobsite_id, :customer_id

  belongs_to :company

  validates :business, :email, :mobile, :name, :role, :twitter, :presence => true
  validates :name, :twitter, :email, :uniqueness => true
  validates_numericality_of :mobile, :presence => true, :only_integer => true
  validates :customer_id, :jobsite_id, :presence => true

  def self.search(search)
    if search
      if session[:customer_id] && session[:jobsite_id]
        if session[:customer_id]=="All" && session[:jobsite_id] == "All"
          where('name LIKE?', "%#{search}%")
        elsif session[:customer_id]!="All" && session[:jobsite_id] == "All"
          where('name LIKE? AND customer_id=?', "%#{search}%", session[:customer_id])
        elsif session[:customer_id]=="All" && session[:jobsite_id] != "All"
          where('name LIKE? AND jobsite_id=?', "%#{search}%", session[:jobsite_id])
        else
          where('name LIKE? AND customer_id=? AND jobsite_id=?', "%#{search}%", session[:customer_id], session[:jobsite_id])
        end
      elsif session[:customer_id] && !session[:jobsite_id]
        if session[:customer_id]=="All"
          where('name LIKE? AND jobsite_id=?', "%#{search}%", session[:jobsite_id])
        else
          where('name LIKE? AND customer_id=? AND jobsite_id=?', "%#{search}%", session[:customer_id], session[:jobsite_id])
        end
      elsif !session[:customer_id] && session[:jobsite_id]
        if session[:jobsite_id]=="All"
          where('name LIKE? AND customer_id', "%#{search}%", session[:customer_id])
        else
          where('name LIKE? AND jobsite_id=? AND customer_id=?', "%#{search}%", session[:jobsite_id], session[:customer_id])
        end
      else
        where('name LIKE? AND customer_id=? AND jobsite_id=?', "%#{search}%", session[:customer_id], session[:jobsite_id])
      end
    else
      scoped
    end
  end
  
end
