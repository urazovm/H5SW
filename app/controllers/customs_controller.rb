class CustomsController < ApplicationController
  before_filter :is_login?
  before_filter :access_role?
  before_filter :display_custom, :only => ["new", "create"]
  
  def index
    if params[:type].present? && params[:type] =="Job"
      @default_tab = (params[:tab] ? params[:tab] : current_login.tabs.find_by_tab_type("Job").id)
    else
      @default_tab = (params[:tab] ? params[:tab] : current_login.tabs.first.id)
    end

    @tabs = current_login.tabs.where("tab_type=?", params[:type]).order("created_at asc")
    @customs = Custom.where("tab_id=? and company_id=? and status=?", @default_tab.to_i, current_login.id, true).order('position asc')
  end

  def display_this_in_new_and_create
    @tabs = current_login.tabs.order("created_at asc")
    @tab = current_login.tabs.find(params[:tab])
  end

  def new
    display_this_in_new_and_create
    @custom = current_login.customs.new
  end

  def create
    display_this_in_new_and_create
    #all the parameters from new form
    @custom = current_login.customs.new(params[:custom])

    #all the custom fields matching this condition
    @customs = Custom.where("company_id =? and tab_id =? and status=?", current_login.id, @custom.tab, true)

    #set the position of the custom element
    if !@customs.empty?
      @positions = @customs.map{|cus| cus.position}
      @custom.position = @positions.compact.sort.last+1
    else
      @custom.position = 1
    end

    #save the custom element
    if @custom.save
      
      #update tab name
      @change_tab_name = current_login.tabs.find(params[:tab])
      @change_tab_name.update_attributes(:name => params[:tab_name])
      
      #save values for textbox, dropdown or calendar
      DropdownValue.create(:custom_id => @custom.id, :company_id => @custom.company_id, :drop_value => params[:drop_down_value])

      flash[:notice] = "Custom field created successfully."
      redirect_to new_custom_path(:tab => @tab.id, :type => @tab.tab_type)
    else
      render 'new'
    end
  end

  def edit
    @custom = Custom.find(params[:id])
    @dropdown_values = DropdownValue.find_by_custom_id_and_company_id(params[:id], current_login.id)
  end

  def update
    @custom = Custom.find(params[:id])
    if @custom.update_attributes(params[:custom])
      render
    else
      render :action => "edit"
    end
  end

  def get_dropdown_values
    @custom = Custom.find(params[:custom_id])
    @drop_downvalue = current_login.dropdown_values.find(params[:dropdown_id])
    render
  end

  def update_dropdown_values
    @custom = Custom.find(params[:dropdown_value][:custom_id])
    @drop_downvalue = current_login.dropdown_values.find(params[:id])
    @drop_downvalue.update_attributes(params[:dropdown_value])
    render
  end


  #delete and hide records
  def destroy
    @custom = Custom.find(params[:id])
    @custom.destroy
  end

  def update_status
    @custom = Custom.find(params[:id])
    @custom.update_attributes(:status => false)
  end
  #end

  #update all the values of dropdown list
  def edit_dropdown
    @custom_id = params[:cus_id]
    @custom = Custom.find(params[:cus_id])
    @dropdown_values =  DropdownValue.find_by_custom_id_and_company_id(params[:cus_id], current_login.id).drop_value
  end

  def update_dropdown
    @custom = Custom.find(params[:id])
    @dropdown_value = DropdownValue.find_by_custom_id_and_company_id(params[:id], current_login.id)
    @dropdown_value.update_attribute(:drop_value, params[:dropdown_value])
  end
  #end of updation of update dropdown values

  def display_custom
    @customs = Custom.where("tab_id=? AND company_id=? AND status=?", params[:tab].to_i, current_login.id, true).order('position asc')
  end

  def update_position
    @custom = Custom.find(params[:id])
    if params[:pos_1] != params[:pos_2]
      if params[:pos_1] > params[:pos_2]
        @find_customs = Custom.where("tab_id=? and company_id=? and position BETWEEN ? and ? and position != ? AND status=?", params[:tab].to_i, current_login.id, params[:pos_2],params[:pos_1],params[:pos_1], true)
        @find_customs.each do |cus|
          cus.update_attribute(:position,cus.position+1)
        end
      elsif params[:pos_1] < params[:pos_2]
        @find_customs = Custom.where("tab_id=? and company_id=? and position BETWEEN ? and ? and position != ? AND status=?", params[:tab].to_i, current_login.id, params[:pos_1],params[:pos_2],params[:pos_1], true)
        @find_customs.each do |cus|
          cus.update_attribute(:position,cus.position-1)
        end
      end
      @custom.update_attribute(:position,params[:pos_2])
    end
    respond_to do |format|
      format.js
    end
  end

  # actions for creating tabs
  def new_tab
    @tabs = current_login.tabs.where("tab_type=?", params[:type]).order("created_at asc")
    @tab = Tab.new
  end

  def create_tab
    @tabs = current_login.tabs.where("tab_type=?", params[:type]).order("created_at asc")
    @tab = Tab.new(params[:tab])

    if @tabs && @tabs.count >= 2
      flash[:error] = "sorry"
      render 'new_tab'
    else
      if @tab.save
        flash[:notice] = "Custom Tab for #{params[:type]} created successfully"
        redirect_to new_tab_customs_path(:type=> params[:type])
      else
        render 'new_tab'
      end
    end
  end

  def update_tab
     @tabs = current_login.tabs.order("created_at asc")
    @tab = Tab.find(params[:id])
    @tab.update_attribute(:name, params[:updated_name])
  end
  # end of the action for creating tabs
end
