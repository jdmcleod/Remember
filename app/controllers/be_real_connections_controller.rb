class BeRealConnectionsController < ApplicationController
  def new
    @be_real_connection = BeRealConnection.find_or_initialize_by(user_id: @current_user.id)
  end

  def create
    phone_number = params[:be_real_connection][:phone_number]

    google_client = GoogleApi::V1::Client.new
    session_info = google_client.request_otp(phone_number)

    if session_info.nil?
      @be_real_connection = BeRealConnection.find_or_initialize_by(user_id: @current_user.id)
      render :new
      return
    end

    @be_real_connection = BeRealConnection.new(user_id: @current_user.id, session_info: session_info)

    if @be_real_connection.save
      redirect_to otp_user_be_real_connection_url(@current_user, @be_real_connection)
    else
      render :new
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
    refresh_response = google_client.refresh_firebase(otp_response['refreshToken'])
    authorize_response = google_client.authorize_with_bereal(refresh_response['idToken'])

    binding.irb

    if !authorize_response['error']
      @be_real_connection.update(
        bereal_access_token: authorize_response['access_token'],
        firebase_refresh_token: otp_response['refreshToken'],
        firebase_id_token: refresh_response['idToken'],
        token_type: authorize_response['token_type'],
        expiration: DateTime.current + refresh_response['expires_in'].seconds,
        uid: otp_response['localId'],
        is_new_user: otp_response['isNewUser']
      )

      redirect_to profile_user_url(@current_user)
    else
      render :otp
    end
  end

  private

  def set_be_real_connection
    @be_real_connection = BeRealConnection.find_by(user_id: @current_user.id, id: params[:id])
  end
end
