class SettingsController < ApplicationController
  before_filter :access_role?
  def index
  end
end
