require "rails_helper"

feature "Answers list", %q{
  In order to see all answers to a certain question
  As an authenticated and non autentificated user
  I want to be able see all answers to a question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question, user: user) }

  scenario "Logged user see all answers to current question" do
    sign_in(user.email, user.password)
    visit questions_path
    click_link question.title

    expect(current_path).to eq question_path(question)
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
  end

  scenario "Non logged user see all answers to current question" do
    visit questions_path
    click_link question.title

    expect(current_path).to eq question_path(question)
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
  end
end
