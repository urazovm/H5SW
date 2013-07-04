class ItemsController < ApplicationController
  before_filter :is_login?
   
  respond_to :html, :json
  before_filter :session_types

  def index
    @items = current_login.items.all
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
    @item.company_id = current_login.id

    if @item.save
      flash[:notice]= "Item was successfully created "
      redirect_to items_path
    else
      render :action => "new"
    end
  end



  def show
    @item = Item.find(params[:id])
    redirect_to items_path
  end

  def update
    @item = Item.find(params[:id])
     
    if @item.update_attributes(params[:item])
      respond_with @item
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

  def autocomplete_items
    @not_names = params[:not_list].split(',').join("','")
    @items = current_login.items.where("name LIKE '#{params[:name]}%' and name NOT IN ('#{@not_names}')")
    respond_to do |format|
      format.js
    end
  end

  def sub_total
    @total = 0
    @items = Item.where("name='#{params[:name]}'")
    if @items
      @items.each do |it|
        @total+= (it.qty.to_f*it.unit_price.to_f)
      end
    end
    @total+= params[:sub_to].to_f
    respond_to do |format|
      format.js
    end
  end
end
