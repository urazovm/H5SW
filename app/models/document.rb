class Document < ActiveRecord::Base
  attr_accessible :description, :document, :company_id, :documentable_id, :documentable_type, :jobsite_id, :document_file_name
  belongs_to :documentable, :polymorphic => true
  has_attached_file :document
  validates_format_of :document_file_name, :with => %r{\.(docx|doc|pdf|zip|jpg|jpeg|gif|png|tif|tiff|txt|ppt|pptx|xls|xlsx)$}i, :message => "Only allow docx|doc|pdf|zip|jpg|jpeg|gif|png|tif|tiff|txt|ppt|pptx|xls|xlsx."
   
def self.search(search)
  if search
      where('document_file_name LIKE?', "%#{search}%")
    else
      scoped
    end
end
end