class BeRealConnectionsController < ApplicationController
  def profile
    set_be_real_connection

    @profile = @be_real_connection.person_record
  end

  def friends
    set_be_real_connection

    @profile = @be_real_connection.person_record
    @friend_collection = @be_real_connection.friends
  end

  def memories
    set_be_real_connection

    @profile = @be_real_connection.person_record
    @memory_collection = @be_real_connection.memories
    @memory_count = 15
  end

  def new
    set_new_be_real_connection
  end

  def create
    google_client = BeRealApi::V1::GoogleClient.new
    session_info = google_client.request_otp(params[:be_real_connection][:phone_number])

    if session_info.nil?
      set_new_be_real_connection
      # TODO: Flash message: "Failed to send one-time password."
      render :new, status: :unprocessable_entity
      return
    end

    @be_real_connection = BeRealConnection.new(
      user_id: @current_user.id,
      session_info: session_info,
      status: BeRealConnection.statuses[:otp_requested]
    )

    if @be_real_connection.save
      redirect_to otp_user_be_real_connection_url(@current_user, @be_real_connection), notice: 'One-time password sent to your phone.'
    else
      # TODO: Flash message: "Failed to send one-time password."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    set_be_real_connection

    google_client = BeRealApi::V1::GoogleClient.new
    session_info = google_client.request_otp(params[:be_real_connection][:phone_number])

    if session_info.nil?
      # TODO: Flash message: "Failed to send one-time password."
      render :new, status: :unprocessable_entity
      return
    end

    @be_real_connection.update(
      session_info: session_info,
      status: BeRealConnection.statuses[:otp_requested]
    )

    if @be_real_connection.valid?
      redirect_to otp_user_be_real_connection_url(@current_user, @be_real_connection), notice: 'One-time password sent to your phone.'
    else
      # TODO: Flash message: "Failed to send one-time password."
      render :new, status: :unprocessable_entity
    end
  end

  def otp
    set_be_real_connection
  end

  def submit_otp
    set_be_real_connection

    one_time_password = params[:be_real_connection][:otp]

    google_client = BeRealApi::V1::GoogleClient.new
    otp_response = google_client.submit_otp(@be_real_connection.session_info, one_time_password)

    if otp_response['error']
      # TODO: Flash message: "Failed to submit one-time password."
      render :otp, status: :unprocessable_entity
      return
    end

    connection_refreshed = @be_real_connection.refresh_connection(otp_response['refreshToken'], otp_response['localId'], otp_response['isNewUser'])

    if connection_refreshed
      redirect_to profile_users_url
      else
      # TODO: Flash message: "Failed to establish connection."
      render :otp, status: :unprocessable_entity
    end
  end

  private

  def set_new_be_real_connection
    @be_real_connection = BeRealConnection.find_or_initialize_by(user_id: @current_user.id) do |connection|
      connection.status = BeRealConnection.statuses[:disconnected]
    end
  end

  def set_be_real_connection
    @be_real_connection = BeRealConnection.find_by(user_id: @current_user.id, id: params[:id])
  end
end
