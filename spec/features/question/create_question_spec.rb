require_relative "../feature_helper"

feature "Create question", %q{
  In order to get answer from community
  As an authenticated user
  I want to be able ask some questions
} do
  given(:user) { create(:user) }

  scenario "Logged user ask question", js: true  do
    sign_in(user.email, user.password)

    visit questions_path
    click_on "Задать вопрос"
    fill_in "Заголовок", with: "What? Abcdf Test"
    fill_in "Вопрос", with: "What? What? What?"
    click_on "Создать"

    expect(page).to have_content "Вопрос успешно создан."
    expect(page).to have_content "What? Abcdf Test"
  end

  scenario "Non logged user ask question" do
    visit questions_path

    expect(page).to_not have_content "Задать вопрос"
  end
end
