class CustomsController < ApplicationController
  before_filter :is_login?
  before_filter :access_role?
  before_filter :display_custom, :only => ["new", "create"]
  
  def index
    if params[:type] && params[:tab]
      @customs = Custom.where("cus_type=? and tab=? and company_id=?", params[:type], params[:tab], current_login.id).order('position desc')
    end
  end

  def new
    @custom = current_login.customs.new
  end

  def create
    @custom = current_login.customs.new(params[:custom])
    session[:type] = params[:custom][:cus_type]
    session[:tab] = params[:custom][:tab] != nil ? params[:custom][:tab] : params[:tab]
    @customs = Custom.where("company_id = '#{current_login.id}' and cus_type = '#{@custom.cus_type}' and tab = '#{@custom.tab}'")
    if !@customs.empty?
      @positions = @customs.map{|cus| cus.position}
      @custom.position = @positions.compact.sort.last+1
    else
      @custom.position = 1
    end
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
      @customs = Custom.where("cus_type=? and tab=? and company_id=?", session[:type], session[:tab], current_login.id).order('position asc')
    else
      @customs = Custom.where("cus_type='Customer' AND tab='#{params[:tab]}' AND company_id=?", current_login.id).order('position asc')
    end
  end

  def update_position
    @custom = Custom.find(params[:id])
    if params[:pos_1] != params[:pos_2]
      cus_type = params[:type] ? params[:type] : session[:type]
      tab = params[:tab] ? params[:tab] : session[:tab]
      if params[:pos_1] > params[:pos_2]
        @find_customs = Custom.where("cus_type=? and tab=? and company_id=? and position BETWEEN ? and ? and position != ?", cus_type, tab, current_login.id, params[:pos_2],params[:pos_1],params[:pos_1])
        @find_customs.each do |cus|
          cus.update_attribute(:position,cus.position+1)
        end
      elsif params[:pos_1] < params[:pos_2]
        @find_customs = Custom.where("cus_type=? and tab=? and company_id=? and position BETWEEN ? and ? and position != ?", cus_type, tab, current_login.id, params[:pos_1],params[:pos_2],params[:pos_1])
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
end
