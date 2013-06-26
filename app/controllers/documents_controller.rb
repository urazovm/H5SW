class DocumentsController < ApplicationController
  
  before_filter :get_documents, :except => ["index"]
 
  def index
    @document = current_company.documents.new()
    @documents = search_by_session_type("document",current_company.documents.search(params[:search]),params[:type]).paginate(:per_page => 10, :page => params[:page])
  end

  def create
    @document = current_company.documents.new(params[:document])
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
     @documents = search_by_session_type("document", current_company.documents, params[:type].to_s).order("created_at desc").paginate(:per_page => 5, :page => params[:page])
  end
end