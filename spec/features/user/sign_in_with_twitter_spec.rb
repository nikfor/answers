require_relative "../feature_helper"

feature "User sign in from twitter", %q{
  In order to can fast sign_in
  As an user
  I want to be able to sign in from twitter
} do


  scenario "sign in with exist twitter account first time" do
    visit root_path
    click_on "Войти"

    expect(page).to have_content "Sign in with Twitter"
    mock_auth_hash("twitter")
    click_on "Sign in with Twitter"
    expect(page).to have_content "Введите Email:"
    fill_in :email, with: "ivan@ivan.ru"
    click_on "Отправить"

    expect(page).to have_content "ivan@ivan.ru"
    expect(page).to have_content "Выйти"
  end

  scenario "sign in with exist twitter account second time (without email request)" do
    visit root_path
    click_on "Войти"

    mock_auth_hash("twitter")
    click_on "Sign in with Twitter"
    fill_in :email, with: "ivan@ivan.ru"
    click_on "Отправить"
    click_on "Выйти"

    click_on "Войти"
    click_on "Sign in with Twitter"

    expect(page).to have_content "ivan@ivan.ru"
    expect(page).to have_content "Выйти"
  end

  scenario "sign in with invalid twitter credentials" do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    visit root_path
    click_on "Войти"

    click_on "Sign in with Twitter"

    expect(page).to have_content "Вы не можете войти в систему с учётной записью из Twitter"
    expect(page).to_not have_content "Выйти"
  end
end
