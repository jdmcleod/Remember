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

  # API caching and retrieval
  # TODO: How do we invalidate this cache?
  # Set a expired_at field and check if it's expired
  # Probably want to expire the cache every 5 minutes

  def person_record
    cached_data = retrieve_from_be_real_cache(:person_record)
    BeRealApi::V1::Models::PersonRecord.new(cached_data)
  end

  def friends
    cached_data = retrieve_from_be_real_cache(:friends)
    BeRealApi::V1::Models::FriendCollection.new(cached_data)
  end

  private

  def retrieve_from_be_real_cache(api_method = :person_record)
    cached_data = cached_be_real_data[api_method.to_s]

    if cached_data.nil?
      cached_data = api_client.send(api_method)
      cached_be_real_data[api_method.to_s] = cached_data
      save
    end

    cached_data
  end

  def api_client
    @api_client ||= BeRealApi::V1::Client.new(bereal_access_token)
  end
end
