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
   @document.destroy
    respond_to do |format|
      format.js
    end 
 end

  def get_documents
    @documents = current_company.documents.where("documentable_type=?", params[:type].to_s).order("created_at desc").search(params[:search]).paginate(:per_page => 5, :page => params[:page])
  end
end

