class Job < ActiveRecord::Base
   
  has_attached_file :image
  attr_accessible :add_items, :assigned_to, :class_type, :due_date, :reference_no, :sales_person, :status, :sub_total, :summary, :job_number, :customer_id, :company_id, :contact_id, :jobsite_id, :name, :signature, :image
  # Data validations
  validates :reference_no, :class_type, :status, :assigned_to, :due_date, :sub_total, :presence => true
  validates :reference_no, :uniqueness => true
  #validates_numericality_of :sub_total, :greater_than => 0, :message => "must be greater than 0"
  #validates :sub_total, :format => { :with => /^[0-9]{1,5}((\.[0-9]{1,5})?)$/, :message => "should be a valid price less than 6 digit number" }
  validates :customer_id, :presence => true

  belongs_to :customer
  belongs_to :company
  has_many :notes, :as => :notable
  has_many :documents, :as => :documentable
  has_many :items
  has_many :jobtimes


  def self.search(search)
    if search
      where('reference_no ILIKE? OR status ILIKE? OR summary ILIKE?', "%#{search}%","%#{search}%","%#{search}%" )
    else
      scoped
    end
  end
  
  def self.total_on(date)
    where("status='open' AND date(created_at) = ?",date).count
  end

  def self.closed_jobs(date)
    where("status='closed' AND date(updated_at) = ?",date).count
  end

	def self.open_jobs(date)
   @job = Date.today-date
  end
end
