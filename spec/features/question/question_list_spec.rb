require "rails_helper"

feature "Question list", %q{
  In order to see all questions
  As an authenticated and non autentificated user
  I want to be able see all questions
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user, email: "another@email.com") }
  given!(:question) { create(:question) }
  given!(:question2) { create(:question, title: "another_title", user: another_user) }

  scenario "Logged user see all questions" do
    sign_in(user.email, user.password)
    visit questions_path

    expect(page).to have_content question.title
    expect(page).to have_content question2.title
  end

  scenario "Non logged user see all questions" do
    visit questions_path
    expect(page).to have_content question.title
    expect(page).to have_content question2.title
  end
end
