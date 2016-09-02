require_relative "../feature_helper"

feature "User registration", %q{
  In order to be able to log in
  As an user
  I want to be able to sign up
} do

  given(:user) { create(:user) }
  before { visit new_user_registration_path }

  scenario "User try to sign up" do
    sign_up("test@test.com", "12345678", "12345678")
    expect(page).to have_content "Добро пожаловать! Вы успешно зарегистрировались."
    expect(page).to have_content "Выйти"
    expect(page).to have_content "test@test.com"
    expect(page).to_not have_content "Войти"
    expect(current_path).to eq root_path
  end

  scenario "User try to sign up with exist email" do
    sign_up(user.email, user.password, user.password)
    expect(page).to have_content "Пользователь с данным email уже зарегистрирован"
  end

  scenario "User try to sign up with invalid email" do
    sign_up("ttestcom", "12345678", "12345678")
    expect(page).to have_content "Неверный email"
  end

  scenario "User try to sign up with not equal password and password confirmation" do
    sign_up("test@test.com", "12345678", "00000000")
    expect(page).to have_content "Пароль и подтверждение не совпадают"
  end

end
