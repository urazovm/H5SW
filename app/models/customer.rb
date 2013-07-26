class Customer < ActiveRecord::Base
  acts_as_gmappable :check_process => false
  attr_accessible :company_id, :action,:types, :company_name, :parent_billing, :address1, :address2, :city, :state, :zip, :contact, :website, :business_type, :terms_client, :status, :account, :phone, :contact_id,:phone1, :phone2, :phone3, :phone4
  attr_accessor :phone1, :phone2, :phone3, :phone4
  belongs_to :company
  has_many :jobs
  has_many :contacts
  has_many :jobsites
  
  has_many :documents, :as => :documentable
  has_many :notes, :as => :notable
  has_many :items
  has_many :jobtimes


  validates:company_name, :presence => true

  validates :account, :uniqueness => true
  before_save :make_phone
  def self.search(search)
    if search
      where('company_name ILIKE?', "%#{search}%")
    else
      scoped
    end
  end


  def make_phone
    if (@phone1.present? and @phone2.present? and @phone3.present?) and !@phone4.present?
      self.phone = @phone1.to_s+"-"+@phone2.to_s+"-"+@phone3.to_s
    elsif (@phone1.present? and @phone2.present? and @phone3.present?) and @phone4.present?
      self.phone = @phone1.to_s+"-"+@phone2.to_s+"-"+@phone3.to_s+"/"+@phone4.to_s
    end
  end

  def phone1
    self.phone.to_s.split('-')[0] if self.phone.present?
  end

  def phone2
    self.phone.to_s.split('-')[1]  if self.phone.present?
  end

  def phone3
    self.phone.to_s.split('-')[2].split('/')[0]  if self.phone.present? and !self.phone.to_s.split('-')[2].nil?
  end

  def phone4
    self.phone.to_s.split('-')[2].split('/')[1]  if self.phone.present? and !self.phone.to_s.split('-')[2].nil?
  end

 

  def gmaps4rails_address
  "#{self.city}, #{self.state}, #{self.zip}"
  end
  def gmaps4rails_infowindow
    "Customer: <br/><b>Name:&nbsp;</b> #{self.company_name}<br /><b>City:&nbsp;</b>#{self.city}<br /><b>State:&nbsp;</b> #{self.state}<br /><b>Zip:&nbsp;</b> #{self.zip}<br /> <b>Phone:&nbsp;</b>#{self.phone}<br />"
  end

end
