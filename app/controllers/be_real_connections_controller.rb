class BeRealConnectionsController < ApplicationController
  def new
    set_new_be_real_connection
  end

  def create
    google_client = GoogleApi::V1::Client.new
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

    google_client = GoogleApi::V1::Client.new
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

    google_client = GoogleApi::V1::Client.new
    otp_response = google_client.submit_otp(@be_real_connection.session_info, one_time_password)

    if otp_response['error']
      # TODO: Flash message: "Failed to submit one-time password."
      render :otp, status: :unprocessable_entity
      return
    end

    refresh_response = google_client.refresh_firebase(otp_response['refreshToken'])

    if refresh_response['error']
      # TODO: Flash message: "Failed to submit one-time password."
      render :otp, status: :unprocessable_entity
      return
    end

    authorize_response = google_client.authorize_with_bereal(refresh_response['id_token'])

    if authorize_response['error']
      # TODO: Flash message: "Failed to submit one-time password."
      render :otp, status: :unprocessable_entity
      return
    end

    if !authorize_response['error']
      @be_real_connection.update(
        status: BeRealConnection.statuses[:connected],
        bereal_access_token: authorize_response['access_token'],
        firebase_refresh_token: otp_response['refreshToken'],
        firebase_id_token: refresh_response['id_token'],
        token_type: authorize_response['token_type'],
        expiration: DateTime.current + (refresh_response['expires_in'].to_i * 1000).seconds,
        uid: otp_response['localId'],
        is_new_user: otp_response['isNewUser']
      )

      redirect_to profile_users_url
    else
      render :otp
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
