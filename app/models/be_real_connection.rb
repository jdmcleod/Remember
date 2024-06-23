class BeRealConnection < ApplicationRecord
  belongs_to :user

  enum :status, { disconnected: 0, otp_requested: 1, connected: 2 }, prefix: true, scopes: false

  attr_reader :phone_number, :otp

  # TODO: Something seems to get messed up.
  # After a certain amount of time, all requests start to fail.
  # I think it's because the access token expires. Even after we establish the connection,
  # we probably need to refresh the token somehow. I need to figure out how to do that.

  def connected?
    status_connected? && bereal_access_token.present? && !expired?
  end

  def expired?
    expiration < DateTime.current
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

  private

  def api_client
    @api_client ||= BeRealApi::V1::Client.new(self)
  end
end
