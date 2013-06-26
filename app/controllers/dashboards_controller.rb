class DashboardsController < ApplicationController
  
  before_filter :is_login?

  def index
    @users = Uesr.all
  end
end
