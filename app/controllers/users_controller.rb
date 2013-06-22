class UsersController < ApplicationController

  def index
    @users = current_company.users
    @user = User.new
  end

  def new
    @user = User.new
  end

  def create
    @user = current_company.users.new(params[:user])
    @user.save
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.js
    end
  end
end
