class UsersController < ApplicationController
  def profile
    @user = current_user

    if @user.be_real_connected?
      @be_real_connection = @user.be_real_connection
      @be_real_person = @be_real_connection.person_record
    end
  end
end
