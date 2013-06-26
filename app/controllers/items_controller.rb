class ItemsController < ApplicationController

  before_filter :is_login?
 
  def index
    @items = current_company.items.all
  end

  def new
    @item = Item.new
    session_types
  end


  def edit
    session_types
    @item = Item.find(params[:id])
  end

   def create
     @item = Item.new(params[:item])
     @item.company_id = current_company.id
     
     session_types
     if @item.save
       flash[:notice]= "Item was successfully created "
       redirect_to items_path
     else
       render :action => "new"
     end
   end


   def update
     @item = Item.find(params[:id])
     session_types
     if @item.update_attributes(params[:item])
       flash[:notice] = "item was successfully updated"
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


   def session_types
    
    @customer_id = session[:customer_id]
    @jobsite_id = session[:jobsite_id]
    @job_id = session[:job_id]

    @job_id ? @job_id == "All" ? nil : @job = Jobsite.find(@job_id) : nil
    @customer_id ? @customer_id=="All" ? nil : @customer = Customer.find(@customer_id) : nil
    @jobsite_id ? @jobsite_id == "All" ? nil : @jobsite = Jobsite.find(@jobsite_id) : nil

  end
end
