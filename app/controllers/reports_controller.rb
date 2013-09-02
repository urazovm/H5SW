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

    if current_login.inventories.exists?(:job_id => @job.id) || current_login.jobtimes.exists?(:job_id => @job.id)
      @items = current_login.inventories.where("job_id = ?", @job.id)
      if @items.present?
        @items.each do |item|
          line_item = Quickeebooks::Online::Model::InvoiceLineItem.new
          if item.description.present?
            line_item.desc = item.description
          else
            line_item.desc = item.name
          end
          # line_items.item_id = Item.find(@job.item_id).quickbook_item_id
          line_item.unit_price = item.unit_price
          line_item.quantity = item.qty.to_f
          line_item.amount = (item.unit_price.to_f * item.qty.to_f)     # unit_price * qty

          # push each line items in invoice line_items
          invoice.line_items << line_item
        end
      end

      @items = current_login.jobtimes.where("job_id =?", @job.id)
      if @items.present?
        @items.each do |item|
          line_item = Quickeebooks::Online::Model::InvoiceLineItem.new
          
          hrs = item.qty.split(":")[0]
          min = item.qty.split(":")[1]
          sec = item.qty.split(":")[2]
          
          qty = hrs.to_f + min.to_f/60 + sec.to_f/3600
          line_item.quantity = qty
          line_item.unit_price = item.price.to_f/qty

          # display service item name in description
          service_item = Item.find(item.service)
          line_item.desc = service_item.name

          if item.billable == true
            line_item.amount = item.price
          end

          invoice.line_items << line_item
        end
      end

      invoice_service.create(invoice)
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
