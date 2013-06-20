class Note < ActiveRecord::Base
  attr_accessible :note_type, :description, :notable_type, :notable_id, :company_id
  belongs_to :customer,  :polymorphic => true
  belongs_to :job,  :polymorphic => true
  belongs_to :company
end
