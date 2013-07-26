class CustomsController < ApplicationController
  before_filter :is_login?
  before_filter :access_role?
  before_filter :display_custom, :only => ["new", "create"]
  
  def index
    if params[:type] && params[:tab]
      @customs = Custom.where("type=? and tab=? and company_id=?", params[:type], params[:tab], current_login.id).order('created_at desc')
    end
  end

  def new
    @custom = current_login.customs.new
  end

  def create
    @custom = current_login.customs.new(params[:custom])
    session[:type] = params[:custom][:type]
    session[:tab] = params[:custom][:tab] != nil ? params[:custom][:tab] : params[:tab]
    
    if @custom.save
      if @custom.field == 'Dropdown List'
        params[:drop_down_value].split(",").each do |dval| 
          DropdownValue.create(:custom_id => @custom.id, :drop_value => dval )
        end
      elsif @custom.field == "Text Box" || @custom.field == "Calendar"
        DropdownValue.create(:custom_id => @custom.id, :drop_value => params[:drop_down_value])
      end

      flash[:notice] = "Custom field created successfully."
      redirect_to new_custom_path(:tab => session[:tab])
    else
      render 'new'
    end
  end



#  def add_drop_values
#    @dropdown_val = DropdownValue.new(:drop_value => params[:drop_val])
#    @dropdown_val.save
#    respond_to do |format|
#      format.js
#    end
#  end

#  def default_link
#    if params[:controller]=="customs" && params[:action]=="new"
#    else
#      if params[:controller]=="customs"
#        params[:type] ? (params[:type] == "") ? (redirect_to customs_path(:type => "Customer")) : '' : (redirect_to customs_path(:type => "Customer"))
#      end
#    end
#  end

  def display_custom
    if session[:type] && session[:tab]
      @customs = Custom.where("type=? and tab=? and company_id=?", session[:type], session[:tab], current_login.id).order('created_at desc')
    else
      @customs = Custom.where("type='Customer' AND tab='#{params[:tab]}' AND company_id=?", current_login.id).order('created_at desc')
    end
  end
end
