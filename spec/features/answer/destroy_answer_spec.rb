require "rails_helper"

feature "Destroy answer", %q{
  In order to other users willn't see my answer
  As an authenticated user
  I want to be able destroy my answer
} do
  given(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:other_user_answer) { create(:answer, body: "Абрвалг",
                                               user: other_user,
                                               question: question) }

  scenario "Logged user destroy own answer" do
    sign_in(user.email, user.password)

    visit questions_path
    click_on "Посмотреть"
    click_on("Удалить", match: :first)

    expect(page).to have_content "Ответ успешно удален"
    expect(current_path).to eq questions_path
  end

  scenario "Logged user destroy other user answer" do
    sign_in(user.email, user.password)

    visit questions_path
    click_on "Посмотреть"
    all('a', text: 'Удалить')[1].click


    expect(page).to have_content "Вы не можете удалять чужие ответы"
    expect(current_path).to eq questions_path
  end

  scenario "Non logged user create answer" do
    visit questions_path
    click_on "Посмотреть"
    click_on("Удалить", match: :first)

    expect(page).to have_content "Вам необходимо войти в систему или зарегистрироваться."
  end
end
