class BeRealConnection < ApplicationRecord
  belongs_to :user

  attr_reader :phone_number, :otp

  def expired?
    expiration < DateTime.current
  end
end
