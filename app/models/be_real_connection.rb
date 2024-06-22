class BeRealConnection < ApplicationRecord
  belongs_to :user

  enum :status, { disconnected: 0, otp_requested: 1, connected: 2 }, prefix: true, scopes: false

  attr_reader :phone_number, :otp

  def connected?
    status_connected? && bereal_access_token.present? && !expired?
  end

  def expired?
    expiration < DateTime.current
  end

  def person_record
    cached_data = cached_be_real_data['person_record']

    if cached_data.nil?
      client = BeRealApi::V1::Client.new(bereal_access_token)
      cached_data = client.person_record
      cached_be_real_data['person_record'] = cached_data
      save
    end

    BeRealApi::V1::Models::PersonRecord.new(cached_data)
  end
end
