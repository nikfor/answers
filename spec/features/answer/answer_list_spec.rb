require "rails_helper"

feature "Answers list", %q{
  In order to see all answers to a certain question
  As an authenticated and non autentificated user
  I want to be able see all answers to a question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answer2) { create(:answer,
                                    body: "Или 12? Смотря в какой системе счисления",
                                    question: question) }

  scenario "Logged user see all answers to current question" do
    sign_in(user.email, user.password)
    visit questions_path
    click_on "Посмотреть"

    expect(current_path).to eq question_answers_path(question)
    expect(page).to have_content answer.body
    expect(page).to have_content answer2.body
  end

  scenario "Non logged user see all answers to current question" do
    visit questions_path
    click_on "Посмотреть"

    expect(current_path).to eq question_answers_path(question)
    expect(page).to have_content answer.body
    expect(page).to have_content answer2.body
  end
end
