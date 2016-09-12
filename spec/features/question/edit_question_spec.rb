require_relative "../feature_helper.rb"

feature "Question editing", %q{
  In order to correct error
  As an author of question
  I want to be able edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe "Logged user" do
    before { sign_in(user.email, user.password) }

    context "edit own question" do
      before do
        question.update(user: user)
        visit question_path(question)
      end

      scenario "and sees edit link for his question" do
        within ".question-block" do
          expect(page).to have_link "Редактировать"
        end
      end

      scenario "with valid arguments", js: true do
        within ".question-block" do
          click_on "Редактировать"
          fill_in "Заголовок", with: "New edit title"
          fill_in "Вопрос", with: "New edit body"
          click_on "Сохранить"
          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.body
          expect(page).to have_content "New edit title"
          expect(page).to have_content "New edit body"
          expect(page).to_not have_selector "#textarea"
          expect(page).to_not have_selector "input#question_title"
        end
      end

      scenario "with invalid params", js: true do
        within ".question-block" do
          click_on "Редактировать"
          fill_in "Заголовок", with: ""
          fill_in "Вопрос", with: ""
          click_on "Сохранить"
        end
        expect(page).to have_content "Данные вопроса не корректны!"
      end
    end

    scenario "not sees edit link for other user question" do
      visit question_path(question)
      within ".question-block" do
        expect(page).to_not have_link "Редактировать"
      end
    end
  end

  scenario "non logged user not sees edit links" do
    visit question_path(question)
    within ".question-block" do
      expect(page).to_not have_link "Редактировать"
    end
  end

end
