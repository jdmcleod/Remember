class BeRealConnection < ApplicationRecord
  belongs_to :user

  enum :status, { disconnected: 0, otp_requested: 1, connected: 2 }, prefix: true, scopes: false

  attr_reader :phone_number, :otp

  def connected?
    status_connected? && bereal_access_token.present?
  end

  def firebase_expired?
    expiration < DateTime.current
  end

  def refresh_connection(refresh_token = self.firebase_refresh_token, uid = self.uid, is_new_user = self.is_new_user)
    google_client = GoogleApi::V1::Client.new
    refresh_response = google_client.refresh_firebase(refresh_token)

    return false if refresh_response['error']

    authorize_response = google_client.authorize_with_bereal(refresh_response['id_token'])

    return false if authorize_response['error']

    update(
      status: BeRealConnection.statuses[:connected],
      bereal_access_token: authorize_response['access_token'],
      firebase_refresh_token: refresh_token,
      firebase_id_token: refresh_response['id_token'],
      token_type: authorize_response['token_type'],
      expiration: DateTime.current + refresh_response['expires_in'].to_i.seconds, # usually returns 3600 seconds or 1 hour
      uid: uid,
      is_new_user: is_new_user
    )

    valid?
  end

  def person_record
    data = api_client.person_record
    BeRealApi::V1::Models::PersonRecord.new(data)
  end

  def friends
    data = api_client.friends
    BeRealApi::V1::Models::FriendCollection.new(data)
  end

  def memories
    data = api_client.memories
    BeRealApi::V1::Models::MemoryCollection.new(data)
  end

  def memory(date = DateTime.current)
    data = api_client.memories
    collection = BeRealApi::V1::Models::MemoryCollection.new(data)

    collection.for_date(date)
  end

  private

  def api_client
    @api_client ||= BeRealApi::V1::Client.new(self)
  end
end
