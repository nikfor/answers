require_relative "../feature_helper"

feature "Destroy answer", %q{
  In order to other users willn't see my answer
  As an authenticated user
  I want to be able destroy my answer
} do
  given(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario "Logged user destroy own answer" do
    sign_in(user.email, user.password)

    visit questions_path
    click_link question.title
    click_link "Удалить"

    expect(page).to_not have_content answer.body
    expect(page).to have_content "Ответ успешно удален"
    expect(current_path).to eq question_path(question)
  end

  scenario "Logged user destroy other user answer" do
    sign_in(other_user.email, other_user.password)

    visit questions_path
    click_link question.title

    expect(page).to_not have_link "Удалить"
  end

  scenario "Non logged user destroy answer" do
    visit questions_path
    click_link question.title
    expect(page).to_not have_link "Удалить"
  end
end
