class DashboardsController < ApplicationController
  
  before_filter :is_login?
  
  def index
    @json = Jobsite.where(:customer_id => current_login.customers.collect(&:id)).all.to_gmaps4rails
  end
end
