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
    if @person_record
      return @person_record
    end

    client = BeRealApi::V1::Client.new(bereal_access_token)
    @person_record = client.person_record
  end
end
