require "rails_helper"

feature "Destroy question", %q{
  In order to will not see other users my question
  As an authenticated user
  I want to be able destroy my questions
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, title: "Abcdf Test", user: user) }
  given!(:other_user) { create(:user) }
  given!(:other_user_question) { create(:question, title: "Other user question", user: other_user) }

  scenario "Logged user destroy own question" do
    sign_in(user.email, user.password)
    visit questions_path
    click_link("Удалить", match: :first)

    expect(page).to have_content "Вопрос успешно удален"
    expect(current_path).to eq questions_path
    expect(page).to_not have_content "Abcdf Test"
  end

  scenario "Logged user destroy other user question" do
    sign_in(user.email, user.password)

    visit questions_path
    all('a', text: 'Удалить')[1].click

    expect(page).to have_content "Вы не можете удалять чужие вопросы"
    expect(current_path).to eq questions_path
    expect(page).to have_content "Other user question"
  end

  scenario "Non logged user destroy question" do
    visit questions_path
    click_link("Удалить", match: :first)

    expect(page).to have_content "Вам необходимо войти в систему или зарегистрироваться."
  end
end
