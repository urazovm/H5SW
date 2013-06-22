class ContactsController < ApplicationController

  before_filter :is_login?
  before_filter :get_contacts, :only => ["new", "create", "edit", "update", "index"]

  # GET /contacts
  def index
  end

  # GET /contacts/1
  def show
    @contact = Contact.find(params[:id])
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
  end

  # POST /contacts
  def create
    @contact = Contact.new(params[:contact])
    @contact.company_id = current_company.id
    @contact.save
    respond_to do |format|
      format.js
    end
  end

  # PUT /contacts/1
  def update
    @contact = Contact.find(params[:id])
    @update_status = false
    if @contact.update_attributes(params[:contact])
      
      @update_status = true
    else
      @update_status = false
    end
    respond_to do |format|
      format.js
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.js
    end
  end

  def ajax_show
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  private
  def get_contacts
    @contacts = search_by_session(current_company.contacts).order("created_at desc").paginate(:per_page => 5, :page => params[:page])
  end
end
