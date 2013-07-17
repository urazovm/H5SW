class UsersController < ApplicationController
  before_filter :is_login?
  before_filter :access_role?
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
    @user = current_login.users.new(params[:user])
    @user.password = 'qawsed!@#'
    @user.password_confirmation = 'qawsed!@#'
    user_save = false
    if @user.save
      user_save = true
    else
      user_save = false
    end
    unless user_save == false
      @user.update_attributes(:confirmation_token => nil,:confirmed_at => Time.now,:reset_password_token => (0...16).map{(65+rand(26)).chr}.join,:reset_password_sent_at => Time.now)
      CompanyMailer.user_link(@user,current_login).deliver
    end
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
      render
    else
      render :action => "edit"
    end
  end

  private
  def get_users
    @users = current_login.users.order("created_at desc")
  end

end
