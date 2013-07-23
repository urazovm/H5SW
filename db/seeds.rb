# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


(1..10).each do |i|
  Item.create(:itemtype => "SMO_item#{i}", :qty => i, :number => "SMOITEM#{i+1}", :name => "itemsmo#{i}", :description => "good", :unit_cost => i+20, :unit_price => i+10)
  Item.create(:itemtype => "Service", :qty => i, :number => "Service#{i+1}", :name => "service_item#{i+1}", :description => "this is a service item #{i+1}", :unit_cost => i*10, :unit_price => (i*10)+1)
end

