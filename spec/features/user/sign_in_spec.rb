require_relative "../feature_helper"

feature "User sign in", %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario "Registered user try to sign" do
    sign_in(user.email, user.password)
    expect(page).to have_content "Вход в систему выполнен."
    expect(current_path).to eq root_path
  end

  scenario "Non registered user try to sign" do
    sign_in("user123@user.com", "12345678")

    expect(page).to have_content "Неверный Email или пароль."
    expect(current_path).to eq new_user_session_path
  end

end
