require_relative "../feature_helper"

feature "Сreate answer to the chosen question", %q{
  In order to respond chosen question
  As an authenticated user
  I want to be able create answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario "Logged user create valid answer", js: true do
    sign_in(user.email, user.password)
    visit questions_path
    click_link question.title

    fill_in "Ваш ответ:", with: "Тут может быть много вариантов"
    click_on "Создать"

    expect(page).to have_content "Ваш ответ успешно создан."
    expect(current_path).to eq question_path(question)
    within ".answer" do
      expect(page).to have_content "Тут может быть много вариантов"
    end
  end

  scenario "Logged user create invalid answer", js: true do
    sign_in(user.email, user.password)
    visit questions_path
    click_link question.title

    click_on "Создать"

    expect(page).to have_content "Введите хоть что нибудь!"
    expect(current_path).to eq question_path(question)
  end

  scenario "Non logged user create answer" do
    visit questions_path

    click_link question.title

    expect(page).to_not have_content "Ваш ответ"
    expect(page).to_not have_content "Создать"
  end
end
