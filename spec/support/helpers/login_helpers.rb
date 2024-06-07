# frozen_string_literal: true

module LoginHelpers
  def sign_in(user)
    auth = OmniAuth.config.mock_auth[:google]
    auth['info']['name'] = user.name
    auth['info']['email'] = user.email
    visit auth_google_callback_path(:google)
  end
end
