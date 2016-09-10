require_relative "../feature_helper.rb"

feature "Best answer", %q{
  In order to reward author best answer
  As an author of question
  I want to be able mark out best
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:bad_answers) { create_list(:answer, 2, question: question) }
  given!(:good_answer) { create(:answer, body: "i'm good answer", question: question) }

  scenario "click on 'best answer' link at the good answer", js: true do
    sign_in(user.email, user.password)
    question.update(user: user)
    visit question_path(question)

    within page.find('.answer', text: bad_answers[1].body) do
      click_link "Лучший ответ"
      expect(page).to have_content "best"
    end

    within page.find('.answer', text: /i'm good answer/) do
      click_link "Лучший ответ"
      expect(page).to have_content "best"
    end
    expect(page).to have_content("best", count: 1)
  end

  scenario "not sees 'best answer' links if he is on the other user question page", js: true do
    sign_in(user.email, user.password)
    visit question_path(question)

    expect(page).to_not have_link "лучший ответ"
  end

  scenario "non logged user not sees 'best answer' links", js: true do
    visit question_path(question)

    expect(page).to_not have_link "лучший ответ"
  end


end
