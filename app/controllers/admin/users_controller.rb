class Admin::UsersController < ApplicationController
  def profile
    @user = current_user
    @light_sidebar  = true
  end
end
