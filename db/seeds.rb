# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


(1..10).each do |i|
  Item.create(:itemtype => "SMO_item#{i}", :qty => 1, :number => "SMOITEM#{i+1}", :name => "itemsmo#{i}", :description => "good", :unit_cost => i+20, :unit_price => i+10)
end
Item.create(:itemtype => "Service", :qty => 1, :number => "101", :name => "Regular Time", :description => "Service item for regular time", :unit_cost => 250, :unit_price => 200)
Item.create(:itemtype => "Service", :qty => 1, :number => "102", :name => "Over Time", :description => "Service item for over time", :unit_cost => 350, :unit_price => 300)
Item.create(:itemtype => "Service", :qty => 1, :number => "103", :name => "Weekend Time", :description => "Service item for weekend time", :unit_cost => 400, :unit_price => 400)
Item.create(:itemtype => "Service", :qty => 1, :number => "104", :name => "Travel Time", :description => "Service item for travel time", :unit_cost => 525, :unit_price => 500)
Item.create(:itemtype => "Service", :qty => 1, :number => "105", :name => "Part Time", :description => "Service item for part time", :unit_cost => 610, :unit_price => 600)

#create Tabs
Tab.create(:name => "Customer Tab 1", :tab_type => "Customer", :position => 1)
Tab.create(:name => "Customer Tab 2", :tab_type => "Customer", :position => 2)
Tab.create(:name => "Job Tab 1", :tab_type => "Job", :position => 3)
Tab.create(:name => "Job Tab 2", :tab_type => "Job", :position => 4)