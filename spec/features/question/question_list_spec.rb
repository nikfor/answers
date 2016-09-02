require_relative "../feature_helper"

feature "Question list", %q{
  In order to see all questions
  As an authenticated and non autentificated user
  I want to be able see all questions
} do
  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2, user: user) }

  scenario "Logged user see all questions" do
    sign_in(user.email, user.password)
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end

  scenario "Non logged user see all questions" do
    visit questions_path
    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end
end
