class UsersController < ApplicationController
  before_filter :get_users, :only => ["create", "edit", "update", "index"]
  
  def index
    @user = User.new
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    render
  end

  def create
    @user = current_company.users.new(params[:user])
    @user.save
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.js
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      @update_status = true
    else
      @update_status = false
    end
    render
  end

  private
  def get_users
    @users = current_company.users.order("created_at desc")
  end

end
