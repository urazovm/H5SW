class DocumentsController < ApplicationController
  
  before_filter :get_documents, :except => ["index"]
  before_filter :session_types
 
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


  def document_download
     @document = Document.find(params[:id])
    file_path = @document.document_file_name
    if !file_path.nil?
    send_file "#{Rails.root}/public/system/documents/documents/000/000/#{@document.id}/original/#{file_path}", :x_sendfile => true
    else
       redirect_to documents_url
    end
  end

end