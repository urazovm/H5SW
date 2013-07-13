class DocumentsController < ApplicationController
  before_filter :is_login?
  before_filter :get_documents, :except => ["index"]
  before_filter :session_types
 
  def index
    @document = current_login.documents.new()
    @documents = search_by_session_type("document",current_login.documents.search(params[:search]),params[:type]).paginate(:per_page => 10, :page => params[:page])
    @json = Customer.all.to_gmaps4rails
    @json = Jobsite.all.to_gmaps4rails
  end

  def create
    if params[:file]
      @document = current_login.documents.new(:document => params[:file], :documentable_type => params[:type], :documentable_id => session[:customer_id], :jobsite_id => session[:jobsite_id])
    else
      @document = current_login.documents.new(params[:document])
    end
    @document.save
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    respond_to do |format|
      format.js
    end
  end
  
  def get_documents    
    @documents = search_by_session_type("document", current_login.documents, params[:type].to_s).order("created_at desc").paginate(:per_page => 5, :page => params[:page])
  end

end