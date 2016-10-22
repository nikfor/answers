module OmniauthMacros
  def mock_auth_hash(provider)

    email = nil
    if provider == "facebook"
      email = "test@test.com"
    end

    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
      'provider' => provider,
      'uid' => '123545',
      'info' => { 'email' => email },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end
end
