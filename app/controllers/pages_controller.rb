class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  layout "landing", only: [:home] #render landing layout instead of application

  def home

  end
end
