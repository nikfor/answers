require "rails_helper"

feature "Сreate answer to the chosen question", %q{
  In order to respond chosen question
  As an authenticated user
  I want to be able create answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario "Logged user create answer" do
    sign_in(user.email, user.password)

    visit questions_path
    click_on "Ответить"
    fill_in "Ваш ответ:", with: "Тут может быть много вариантов"
    click_on "Создать"

    expect(page).to have_content "Ваш ответ успешно создан."
    expect(current_path).to eq question_answers_path(question)
    expect(page).to have_content "Тут может быть много вариантов"
  end

  scenario "Non logged user create answer" do
    visit questions_path
    click_on "Ответить"

    expect(page).to have_content "Вам необходимо войти в систему или зарегистрироваться."
  end
end
