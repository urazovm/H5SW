class RolesController < ApplicationController

  def index
    @roles = current_company.roles.all
    @role = current_company.roles.new
  end
  
  def new
    @role = current_company.roles.new
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    @role = current_company.roles.new(params[:role])
    @roles = current_company.roles.all
    @role.save
    respond_to do |format|
      format.js
    end  
  end

  def update
    @role = Role.find(params[:id])
    @roles = current_company.roles.all
    @update_status = false

    if @role.update_attributes(params[:role])
      @update_status = true
    else
      @update_status = false
    end
    respond_to do |format|
      format.js
    end
  end


  def destroy
    @role = Role.find(params[:id])

    @role.destroy
    respond_to do |format|
      format.js
    end
  end

  private
  def get_roles
    @roles = current_company.roles.order("created_at desc")     
  end
end
