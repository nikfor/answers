require_relative "../feature_helper"

feature "User sign in from fb", %q{
  In order to can fast sign_in
  As an user
  I want to be able to sign in from facebook
} do


  scenario "sign in with exist fb account" do
    visit root_path
    click_on "Войти"

    expect(page).to have_content "Sign in with Facebook"
    mock_auth_hash("facebook")
    click_on "Sign in with Facebook"

    expect(page).to have_content "Вход в систему выполнен с учётной записью из facebook."
    expect(page).to have_content "Выйти"
  end

  scenario "sign in with invalid fb credentials" do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    visit root_path
    click_on "Войти"

    expect(page).to have_content "Sign in with Facebook"
    click_on "Sign in with Facebook"

    expect(page).to have_content "Вы не можете войти в систему с учётной записью из Facebook"
    expect(page).to_not have_content "Выйти"
  end
end
