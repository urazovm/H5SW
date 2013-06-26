class ItemsController < ApplicationController

  before_filter :is_login?
  before_filter :session_types

  def index
    @items = current_company.items.all
  end

  def new
    @item = Item.new
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
end
