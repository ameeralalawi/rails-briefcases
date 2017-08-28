class Admin::UsersController < ApplicationController
  def profile
    @user = current_user
  end
end
