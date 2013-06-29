class ContactsController < ApplicationController
   
  before_filter :is_login?
  before_filter :get_contacts, :only => ["create", "edit", "update"]

  # GET /contacts
  def index
   @contacts = search_by_session(current_company.contacts.search(params[:search])).order("created_at desc").paginate(:per_page => 5, :page => params[:page])
  end

  # GET /contacts/1
  def show
    @contact = Contact.find(params[:id])
  end

  # GET /contacts/new
  def new    
    @contacts = search_by_session(current_company.contacts.search(params[:search])).order("created_at desc").paginate(:per_page => 5, :page => params[:page])
    @contact = Contact.new

    @phone1 = params[:contact][:phone1]
    @phone2 = params[:contact][:phone2]
    @phone3 = params[:contact][:phone3]
    @phone4 = params[:contact][:phone4]
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
  end

  # POST /contacts
  def create
    @contact = Contact.new(params[:contact])
    @contact.company_id = current_company.id

    @phone1 = params[:contact][:phone1]
    @phone2 = params[:contact][:phone2]
    @phone3 = params[:contact][:phone3]
    @phone4 = params[:contact][:phone4]
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
