class ItemsController < ApplicationController

  respond_to :html, :json
  before_filter :is_login?
  before_filter :session_types


  def index
    @items = current_company.items.all
  end

  def new
    @item = Item.new
    render :layout => false

  end

  def edit
    
    @item = Item.find(params[:id])
    render :layout => false

  end

  def create
    @item = Item.new(params[:item])
    @item.company_id = current_company.id

    if @item.save
      flash[:notice]= "Item was successfully created "
      redirect_to items_path
    else
      render :action => "new"
    end
  end



  def update
    @item = Item.find(params[:id])
     
    if @item.save
      flash[:notice] = "item was successfully updated."
      redirect_to items_path
    else
      render :action => "edit"
    end
  end
   
 
  def destroy
    @item = Item.find(params[:id])
    if @item.destroy
      flash[:notice] = "item was successfully deleted"
    else
      flash[:error] = "item deletion failed"
    end
    redirect_to items_url
  end
end
