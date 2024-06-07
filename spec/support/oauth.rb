# frozen_string_literal: true

OmniAuth.config.test_mode = true

google_auth = {
  provider: 'google',
  uid: '12345',
  info: {
    name: 'Bilbo Baggins',
    email: 'person@rolemodelsoftware.com'
  }
}

OmniAuth.config.add_mock(:google, google_auth)
