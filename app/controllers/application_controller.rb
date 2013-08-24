class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all
  helper_method :search_by_session
  helper_method :expired_on
  helper_method :current_login
  
  def after_sign_in_path_for(resource_or_scope)
    root_path
  end

  def after_sign_up_path_for(resource_or_scope)
    after_sign_in_path_for(resource_or_scope)
  end

  def is_login?
    unless current_company or current_user
      flash[:error] = "Please login"
      redirect_to '/'
    end
  end

  def session_types
    @job_id = session[:job_id]
    @customer_id = session[:customer_id]
    @jobsite_id = session[:jobsite_id]
    
    @job_id ? @job = Job.find(@job_id) : nil
    @customer_id ? @customer_id=="All"  || @customer_id == 0 ? nil : @customer = Customer.find(@customer_id) : nil
    @jobsite_id ? (@jobsite_id == "All" || @jobsite_id == "None" || @jobsite_id == 0) ? nil : @jobsite = Jobsite.find(@jobsite_id) : nil
  end

  #only applicable for jobsite
  def search_by_customer_id(value)
    if session[:customer_id]
      if session[:customer_id] == "All"
        value
      else
        value.where('customer_id=?', session[:customer_id])
      end
    else
      value
    end
  end

  def search_by_session(value)
    if session[:customer_id] && session[:jobsite_id]
      if session[:customer_id]=="All" && (session[:jobsite_id] == "All" || session[:jobsite_id] == "None")
        value
      elsif session[:customer_id]!="All" && (session[:jobsite_id] == "All" || session[:jobsite_id] == "None")
        value.where('customer_id=?', session[:customer_id])
      elsif session[:customer_id]=="All" && (session[:jobsite_id] != "All" || session[:jobsite_id] != "None")
        value
      else
        value.where('customer_id=? AND jobsite_id=?', session[:customer_id], session[:jobsite_id])
      end
    elsif session[:customer_id] && !session[:jobsite_id]
      if session[:customer_id]=="All"
        value
      else
        value.where('customer_id=?', session[:customer_id])
      end
    else
      value
    end
  end

  def search_by_session_type(model_type, value, type)
    if session[:customer_id] && session[:jobsite_id]
      if session[:customer_id]=="All" && (session[:jobsite_id] == "All" || session[:jobstie_id] == "None")
        if model_type=="document"
          value.where('documentable_type=?', type)
        elsif model_type == "note"
          value.where('notable_type=?', type)
        end
      elsif session[:customer_id]!="All" && (session[:jobsite_id] == "All" || session[:jobsite_id] == "None")
        if model_type=="document"
          value.where('documentable_type=? AND documentable_id=?', type, session[:customer_id])
        elsif model_type=="note"
          value.where('notable_type=? AND notable_id=?', type, session[:customer_id])
        end
      elsif session[:customer_id]=="All" && (session[:jobsite_id] != "All" || session[:jobsite_id] != "None")
        if model_type=="document"
          value.where('documentable_type=?', type)
        elsif model_type=="note"
          value.where('notable_type=?', type)
        end
      else
        if model_type=="document"
          value.where('documentable_type=? AND documentable_id=? AND jobsite_id=?', type, session[:customer_id], session[:jobsite_id])
        elsif model_type=="note"
          value.where('notable_type=? AND notable_id=? AND jobsite_id=?', type, session[:customer_id], session[:jobsite_id])
        end
      end
    elsif session[:customer_id] && !session[:jobsite_id]
      if session[:customer_id]=="All"
        if model_type=="document"
          value.where('documentable_type=?', type)
        elsif model_type=="note"
          value.where('notable_type=?', type)
        end
      else
        if model_type=="document"
          value.where('documentable_type=? AND documentable_id=?', type, session[:customer_id])
        elsif model_type=="note"
          value.where('notable_type=? AND notable_id=?', type, session[:customer_id])
        end
      end
    else
      if model_type=="document"
        value.where('documentable_type=? ', type)
      elsif model_type=="note"
        value.where('notable_type=? ', type)
      end
    end
  end

  def gmap_json
    if !session[:customer_id].nil? && !session[:jobsite_id].nil? && session[:jobsite_id] != 0
      if session[:customer_id]=="All" && (session[:jobsite_id] == "All" || session[:jobsite_id] == "None")
        @json1 = Customer.all.to_gmaps4rails
        @json2 = Jobsite.all.to_gmaps4rails
      elsif session[:customer_id]!="All" && (session[:jobsite_id] == "All" || session[:jobsite_id] == "None")
        @json1 = Customer.find_by_id(session[:customer_id]).to_gmaps4rails
        @json2 = Jobsite.find_all_by_customer_id(session[:customer_id]).to_gmaps4rails
      elsif session[:customer_id]=="All" && (session[:jobsite_id] != "All" || session[:jobsite_id] != "None")
        @json1 = Customer.all.to_gmaps4rails
        @json2 = Jobsite.find_by_id(session[:jobsite_id]).to_gmaps4rails
      else
        @json1 = Customer.find_by_id(session[:customer_id]).to_gmaps4rails
        @json2 = Jobsite.find_by_id(session[:jobsite_id]).to_gmaps4rails
      end
    end
    if !@json2.nil? and !@json1.nil?
      @json = (JSON.parse(@json1) + JSON.parse(@json2)).to_json
    elsif @json2.nil? and !@json1.nil?
      @json = JSON.parse(@json1).to_json
    elsif !@json2.nil? and @json1.nil?
      @json = JSON.parse(@json2).to_json
    else
      @json = []
    end
  end


  # Actions for trial period
  # Create expired_on action for keeping track of how many days remaining in trial period
  # Create payment_notification after 20 days passed and 30 days passed
  # Create trial_period_expired? redirecting to expire notification page after trial expiration
  def expired_on
    ((current_company.created_at + 30.days).to_date - Date.today).round if current_company.present?
  end

  def payment_notification
    # send current_company email for subscription
  end

  def trial_period_expired?
    if expired_on <= 0
      redirect_to trial_expires_path
    end
  end
  # end of Actions for trial period


  # accessing the role set for each user
  def current_login
    current_company ? current_company : current_user.company
  end

  def access_role?
    if current_user
      @user_role = Role.find(current_user.role_id)
      @user_role ? @role_name = @user_role.roll : ""
      @error_message = "You don't have permission to access this page!"
    
      if @user_role
        if @role_name == "Admin"
        else
        
          #customer role
          @customer_role =  @user_role.customer
          if @customer_role == "All"
          elsif @customer_role == "None"
            if params[:controller] == "customers"
              flash[:alert] = @error_message
              redirect_to dashboards_index_path
            end
          elsif @customer_role == "Read-Only"
            if params[:controller] == "customers" && (params[:action] == "edit" || params[:action] == "new")
              flash[:alert] = @error_message
              redirect_to customers_path
            end
          elsif @customer_role == "Add/Read"
            if params[:controller] == "customers" && params[:action] == "edit"
              flash[:alert] = @error_message
              redirect_to customers_path
            end
          end

          #jobs role
          @job_role =  @user_role.jobs
          if @job_role == "All"
          elsif @job_role == "None"
            if params[:controller] == "jobs"
              flash[:alert] = @error_message
              redirect_to dashboards_index_path
            end
          elsif @job_role == "Read-Only"
            if params[:controller] == "jobs" && (params[:action] == "edit" || params[:action] == "new")
              flash[:alert] = @error_message
              redirect_to jobs_path
            end
          elsif @job_role == "Add/Read"
            if params[:controller] == "jobs" && params[:action] == "edit"
              flash[:alert] = @error_message
              redirect_to jobs_path
            end
          end

          #jobtimes role
          @jobtime_role = @user_role.jobtimes
          if @jobtime_role == "Read-Write"
          elsif @jobtime_role == "None"
            if params[:controller] == "jobtimes"
              flash[:alert] = @error_message
              redirect_to dashboards_index_page
            end
          elsif @jobtime_role == "Read-Only"
            if params[:controller] == "jobtimes" && params[:action] == "new"
              flash[:alert] = @error_message
              redirect_to jobtimes_path
            end
          end

          #contacts role
          @contact_role =  @user_role.contacts
          if @contact_role == "All"
          elsif @contact_role == "None"
            if params[:controller] == "contacts"
              flash[:alert] = @error_message
              redirect_to dashboards_index_path
            end
          elsif @contact_role == "Read-Only"
            if params[:controller] == "contacts" && (params[:action] == "edit" || params[:action] == "new")
              flash[:alert] = @error_message
              redirect_to contacts_path
            end
          elsif @contact_role == "Add/Read"
            if params[:controller] == "contacts" && params[:action] == "edit"
              flash[:alert] = @error_message
              redirect_to contacts_path
            end
          end


          #settings_admin role

          @settings_role =  @user_role.settings_admin
          if @settings_role == "All"
          elsif @settings_role == "None"
            if params[:controller] == "users" || params[:controller] == "roles" || (params[:controller] == "customs" && params[:action] == "new") || (params[:controller] == "jobtimes" && params[:action] == "new")
              flash[:alert] = @error_message
              redirect_to dashboards_index_path
            end
          elsif @settings_role == "Read-Only"
            if params[:controller] == "users"
              flash[:alert] = @error_message
              redirect_to dashboards_index_path
            end
          elsif @settings_role == "Add/Read"
            if params[:controller] == "users"
              flash[:alert] = @error_message
              redirect_to dashboards_index_path
            end
          end
        end
      end
    end
  end
end