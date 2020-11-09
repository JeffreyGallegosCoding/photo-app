class WelcomeController < ApplicationController
  # skip the before action on my application controller only for the index
  # do not have to be signed in to view the homepage
  skip_before_action :authenticate_user!, only: [:index]

  def index

  end

end
