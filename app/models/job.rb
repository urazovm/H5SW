class Job < ActiveRecord::Base

  attr_accessible :add_items, :assigned_to, :class_type, :due_date, :reference_no, :sales_person, :status, :sub_total, :summary, :job_number, :customer_id, :company_id, :contact_id, :jobsite_id
  # Data validations
  validates :reference_no, :class_type, :status,  :sales_person, :assigned_to, :due_date, :sub_total, :presence => true
  validates :reference_no, :uniqueness => true
  validates_numericality_of :sub_total, :greater_than => 0, :message => "must be greater than 0"
  validates :sub_total, :format => { :with => /^[0-9]{1,5}((\.[0-9]{1,5})?)$/, :message => "should be a valid price less than 6 digit number" }
  validates :customer_id, :jobsite_id, :presence => true

  belongs_to :customer
  belongs_to :company
  has_many :notes, :as => :notable

  has_many :documents, :as => :documentable

  
  def self.search(search)
    if search
      where('reference_no LIKE?', "%#{search}%")
    else
      scoped
    end
  end
end
