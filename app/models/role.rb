class Role < ActiveRecord::Base
   attr_accessible :role, :module, :customer, :jobs, :contacts, :reports, :settings_admin, :company_id

end
