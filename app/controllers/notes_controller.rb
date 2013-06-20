class NotesController < ApplicationController
  before_filter :get_notes

  def index
    @note = current_company.notes.new
  end

  def create
    @note = current_company.notes.new(params[:note])
    @note.save
    respond_to do |format|
      format.js
    end
  end

  def get_notes
    @notes = current_company.notes.where("notable_type=?", params[:type].to_s).order("created_at desc")
  end
end
