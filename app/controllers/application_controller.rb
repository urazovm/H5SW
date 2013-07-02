class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all
  helper_method :search_by_session

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
    
    @job_id ? @job_id == "All" ? nil : @job = Job.find(@job_id) : nil
    @customer_id ? @customer_id=="All" ? nil : @customer = Customer.find(@customer_id) : nil
    @jobsite_id ? (@jobsite_id == "All" || @jobsite_id == "None") ? nil : @jobsite = Jobsite.find(@jobsite_id) : nil
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
end


# accessing the role set for each user
def current_login
  current_company ? current_company : current_user.company
end

def access_role
  
end