class Tab < ActiveRecord::Base
  attr_accessible :name, :tab_type, :position

  has_many :customs

  validates :name, :uniqueness => {:scope => :tab_type, :message => "Tab with this name is already created"}
end
