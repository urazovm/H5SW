class DocumentsController < ApplicationController
  
  before_filter :get_documents
 
  def index
    @document = current_company.documents.new()
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
    if @document.destroy
      flash[:notice] = "document was successfully deleted."
    else
      flash[:error] = "document deletion is failed. please try again."
    end
    redirect_to documents_url
  end

  def get_documents    
      @documents = search_by_session_type("document", current_company.documents, params[:type].to_s).order("created_at desc").paginate(:per_page => 5, :page => params[:page])
  end
end