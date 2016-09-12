require_relative "../feature_helper.rb"

feature "Answer editing", %q{
  In order fix mistake
  As an author of answer
  I'd want to be able edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe "Logged user" do
    before{ sign_in(user.email, user.password) }

    scenario "sees edit link for his answer" do
      answer.update(user: user)
      visit question_path(question)

      within ".answer" do
        expect(page).to have_link "Редактировать"
      end
    end

    scenario "try to edit his answer", js: true do
      answer.update(user: user)
      visit question_path(question)
      within ".answer" do
        click_on "Редактировать"
        fill_in "Новый ответ", with: "Test12345"
        click_on "Сохранить"
        expect(page).to_not have_content answer.body
        expect(page).to have_content "Test12345"
        expect(page).to_not have_selector "#textarea"
      end
    end

    scenario "not sees edit link for other user answer" do
      visit question_path(question)
      within ".answer" do
        expect(page).to_not have_link "Редактировать"
      end
    end
  end

  scenario "Non logged user try to edit answer" do
    visit question_path(question)

    expect(page).to_not have_link "Редактировать"
  end
end
