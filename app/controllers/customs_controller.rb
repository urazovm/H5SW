class CustomsController < ApplicationController
  before_filter :is_login?
  before_filter :access_role?
  
  def index
    @customs = Custom.where("type=? and company_id=?", params[:type],current_login.id)
  end

  def new
    @custom = current_login.customs.new
  end

  def create
    @custom = current_login.customs.new(params[:custom])
    if @custom.save
      if @custom.field == 'Dropdown List'
        params[:drop_ids].split(",").each do |dval|
          @drop = DropdownValue.find(dval.to_i)
          @drop.update_attribute(:custom_id,@custom.id)
        end
      elsif params[:drop_ids] != nil
        params[:drop_ids].split(",").each do |dval|
          DropdownValue.find(dval.to_i).destroy
        end
      end
      flash[:notice] = "Custom field created successfully."
      redirect_to new_custom_path
    else
      render 'new'
    end
  end

  def add_drop_values
    @dropdown_val = DropdownValue.new(:drop_value => params[:drop_val])
    @dropdown_val.save
    respond_to do |format|
      format.js
    end
  end

  def default_link
    if params[:controller]=="customs" && params[:action]=="new"
    else
      if params[:controller]=="customs"
        params[:type] ? (params[:type] == "") ? (redirect_to customs_path(:type => "Customer")) : '' : (redirect_to customs_path(:type => "Customer"))
      end
    end
  end
  
end
