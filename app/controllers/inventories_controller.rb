class InventoriesController < ApplicationController

  before_filter :is_login?

  respond_to :html,:js
  before_filter :session_types
  
  def index
   # @inventories = current_login.inventories.order("created_at")
   @inventories = current_login.inventories.find_all_by_job_id(session[:job_id])
  end

  def new
    @inventory = Inventory.new
  end

  def edit
    @inventory = Inventory.find(params[:id])
  end

  def create
    @inventory = Inventory.new(params[:inventory])
    @inventory.company_id = current_login.id

    if @inventory.save
      flash[:notice]= "Item was successfully created "
      redirect_to inventories_path
    else
      render :action => "new"
    end
  end

  def update
    @inventory = Inventory.find(params[:id])
    @inventory.subtotal = (params[:inventory][:qty].to_f*@inventory.unit_price) if params[:inventory][:qty].present?
    if @inventory.update_attributes(params[:inventory])
      @inventories = current_login.inventories.order("created_at")
      respond_with @inventory
    else
      render :action => "edit"
    end
  end


  def destroy
    @inventory = Inventory.find(params[:id])
    if @inventory.destroy
      flash[:notice] = "item was successfully deleted"
    else
      flash[:error] = "item deletion failed"
    end
    redirect_to inventories_url
  end
end
