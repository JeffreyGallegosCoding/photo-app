class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # In order to access the application you need to be a logged in user
  before_action :authenticate_user!
end
