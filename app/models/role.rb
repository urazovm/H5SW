class Role < ActiveRecord::Base
  attr_accessible :roll, :module, :customer, :jobs, :contacts, :reports, :settings_admin, :company_id
  belongs_to :company
end
