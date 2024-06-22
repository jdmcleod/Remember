class UsersController < ApplicationController
  def profile
    @user = current_user

    if @user.be_real_connected?
      @be_real_connection = @user.be_real_connection
      @be_real_person = @be_real_connection.person_record
      @be_real_friend_collection = @be_real_connection.friends
      @be_real_memory_collection = @be_real_connection.memories
    end
  end
end
