require "rails_helper"

feature "Destroy question", %q{
  In order to will not see other users my question
  As an authenticated user
  I want to be able destroy my questions
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, title: "Abcdf Test", user: user) }
  given!(:other_user) { create(:user) }

  scenario "Logged user destroy own question" do
    sign_in(user.email, user.password)
    visit questions_path
    click_link("Удалить")

    expect(page).to have_content "Вопрос успешно удален"
    expect(current_path).to eq questions_path
    expect(page).to_not have_content "Abcdf Test"
  end

  scenario "Another user destroy questions" do
    sign_in(other_user.email, other_user.password)

    visit questions_path

    expect(page).to_not have_link "Удалить"
  end

  scenario "Non logged user destroy question" do
    visit questions_path

    expect(page).to_not have_link "Удалить"
  end
end
