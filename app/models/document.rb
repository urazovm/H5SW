class Document < ActiveRecord::Base
  attr_accessible :description, :document, :company_id, :documentable_id, :documentable_type, :jobsite_id
  belongs_to :documentable, :polymorphic => true
  has_attached_file :document
  validates_format_of :document_file_name, :with => %r{\.(docx|doc|pdf|zip)$}i, :message => "Only allow docx|doc|pdf|zip."



def self.search(search)
  if search
    find(:all, :conditions => ['document_file_name LIKE ?', "%#{search}%"])
  else
    find(:all)
  end
end


end
