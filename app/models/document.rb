class Document < ActiveRecord::Base
  attr_accessible :description, :document, :company_id, :documentable_id, :documentable_type, :jobsite_id
  belongs_to :documentable, :polymorphic => true
  has_attached_file :document

  def self.search(search)
    if search
      where('document_file_name LIKE?', "%#{search}%")
    else
      scoped
    end
  end
end
