class DropdownValue < ActiveRecord::Base
  attr_accessible :custom_id, :drop_value, :company_id

  belongs_to :custom
  belongs_to :company
end
