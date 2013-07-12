class DropdownValue < ActiveRecord::Base
  attr_accessible :custom_id, :drop_value
  belongs_to :custom
end
