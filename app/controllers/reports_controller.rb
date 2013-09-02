class ReportsController < ApplicationController
  def index
    @jobs = current_login.jobs.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @job = Job.find(params[:id])
  end

  def push_report_to_quickbook
    oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, current_login.access_token, current_login.access_secret)
    
    invoice_service = Quickeebooks::Online::Service::Invoice.new
    invoice_service.access_token = oauth_client
    invoice_service.realm_id = current_login.realm_id

    customer_service = Quickeebooks::Online::Service::Customer.new
    customer_service.access_token = oauth_client
    customer_service.realm_id = current_login.realm_id


    @job = current_login.jobs.find(params[:id])
    @customer = current_login.customers.find(@job.customer_id)

    invoice = Quickeebooks::Online::Model::Invoice.new

    # created_at and updated_at
    meta_data = Quickeebooks::Online::Model::MetaData.new
    meta_data.create_time = @job.created_at
    meta_data.last_updated_time = @job.updated_at

    invoice.meta_data = meta_data

    # create header parts
    header = Quickeebooks::Online::Model::InvoiceHeader.new
    header.msg = @job.summary
    #header.status = ""         # default 'pending' for open jobs and 'closed' for closed and invoiced job

    # find the customer in quickbook
    customer = customer_service.fetch_by_id(@customer.quickbook_customer_id)
    if customer.present?
      header.customer_id = customer.id
      header.customer_name = customer.name
    end
    # header.sub_total_amount = @job.sub_total
    header.to_be_printed = true
    header.to_be_emailed = true
    header.bill_email = current_login.email
    header.due_date = @job.due_date

    invoice.header = header

    # Line Item: If these line items already in quickbooks then fetch them otherwise create them
    if current_login.inventories.exists?(:job_id => @job.id) || current_login.jobtimes.exists(:job_id => @job.id)

      line_items = Quickeebooks::Online::Model::InvoiceLineItem.new

      @items = current_login.inventories.where("job_id = ?", @job.id)
      if @items.present?
        @items.each do |item|
          line_items.desc = item.description
          #    line_items.amount = item.unit_price
          #        line_items.item_id = item.quickbook_item_id
          line_items.unit_price = item.unit_price
          line_items.quantity = item.qty.to_f
        end
      end

      @items = current_login.jobtimes.where("job_id =?", @job.id)
      if @items.present?
        @items.each do |item|
          #line_items.desc = item.description
          #    line_items.amount = item.unit_price
          #        line_items.item_id = item.quickbook_item_id

          #calculate qty
          hrs = item.qty.split(":")[0]
          min = item.qty.split(":")[1]
          sec = item.qty.split(":")[2]
          
          qty = hrs.to_f + min.to_f/60 + sec.to_f/3600
          line_items.quantity = qty
          line_items.unit_price = item.price.to_f/qty
        end
      end

      invoice.line_items = [line_items]
      # create invoice
      invoice_service.create(invoice)
    else
      # display error message that atleast one line items required
    end
  end
  
  def send_mail
    @job = Job.find(params[:id])
    @company = Company.find(current_login.id)
    CompanyMailer.send_job_report(@company,@job).deliver
    respond_to do |format|
      format.js
    end
  end
  
	  def job_report
		 
	  end

	  def print
         @job = Job.find(params[:id])
		 render :pdf => "reports/print.html.erb"
		 respond_to do |format|
		 format.js
	  end
	 end
end
