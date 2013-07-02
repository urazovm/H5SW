class NotesController < ApplicationController
  before_filter :is_login?
  
  before_filter :get_notes
  before_filter :session_types
  
  def index
    @note = current_login.notes.new()
  end

  def create
    @note = current_login.notes.new(params[:note])
    @note.save
    respond_to do |format|
      format.js
    end
  end

  def edit
    @note = current_login.notes.find(params[:id])
  end

  def update
    @note = current_login.notes.find(params[:id])

    if @note.update_attribute(params[:note])
      redirect_to notes_path(@note), :notice => "Note was successfully updated"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    respond_to do |format|
      format.js
    end
  end

  def get_notes
    @notes = search_by_session_type("note",current_login.notes, params[:type].to_s).order("created_at desc")
  end
end
