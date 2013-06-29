class Contact < ActiveRecord::Base
  attr_accessible :business, :email, :mobile, :name, :role, :twitter, :company_id, :jobsite_id, :customer_id, :phone1, :phone2, :phone3, :phone4

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


  def make_mobile
    if (@phone1.present? and @phone2.present? and @phone3.present?) and !@phone4.present?
      self.mobile = @phone1.to_s+"-"+@phone2.to_s+"-"+@phone3.to_s
    elsif (@phone1.present? and @phone2.present? and @phone3.present?) and @phone4.present?
      self.mobile = @phone1.to_s+"-"+@phone2.to_s+"-"+@phone3.to_s+"/"+@phone4.to_s
    end
  end

  def phone1
    self.mobile.to_s.split('-')[0] if self.mobile.present?
  end

  def phone2
    self.mobile.to_s.split('-')[1]  if self.mobile.present?
  end

  def phone3
    self.mobile.to_s.split('-')[2].split('/')[0]  if self.mobile.present?
  end

  def phone4
    self.mobile.to_s.split('-')[2].split('/')[1]  if self.mobile.present?
  end
  
end
