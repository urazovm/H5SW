class RolesController < ApplicationController

  
  def new
    @role = Role.new
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    @role = Role.new(params[:role])

    if @role.save
      flash[:notice] = "Role was successfully created"
      redirect_to roles_path
    else
      render :action => "new"
    end
  end

  def update
    @role = Role.find(params[:id])

    if @customer.update_attributes(params[:role])
      flash[:notice] = "Role was successfully updated."
      redirect_to roles_path
    else
      render :action => "edit"
    end
  end


  def destroy
    @role = Role.find(params[:id])

    if @role.destroy
      flash[:notice] = "Role was deleted successfully"
    else
      flash[:error] = "Role deletion failed"
    end
    redirect_to roles_url
  end
end
