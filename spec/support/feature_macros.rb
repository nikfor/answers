module FeatureMacros
  def sign_in(email, password)
    visit new_user_session_path
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_on "Log in"
  end

  def sign_up(email, pass, pass_confirmation)
    fill_in "Email", with: email
    fill_in("Password", with: pass, :match => :prefer_exact)
    fill_in "Password confirmation", with: pass_confirmation
    click_on "Sign up"
  end
end
