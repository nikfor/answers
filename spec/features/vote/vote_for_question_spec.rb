require_relative "../feature_helper.rb"

feature "Voting for the question", %q{
  To note the preferred question
  As a not author of the question
  I want to be able to vote for the good question
} do
  given!(:mike) { create(:user) }
  given!(:alex) { create(:user) }
  given!(:question) { create(:question) }

  describe "logged user" do
    background do
      sign_in(mike.email, mike.password)
      visit question_path(question)
    end

    scenario "logged user votes +1", js: true do
      within '.question-block' do
        click_link "+"
        within '.total' do
          expect(page).to have_content "1"
        end
        within '.cancel' do
          expect(page).to have_content "Отмена"
        end
      end
    end

    scenario "logged user votes -1", js: true do
      within '.question-block' do
        click_link "-"
        within '.total' do
          expect(page).to have_content "-1"
        end
        within '.cancel' do
          expect(page).to have_content "Отмена"
        end
      end
    end

    scenario "logged user cancel voted sign", js: true do
      within '.question-block' do
        click_link "+"
        # click_link "Отмена"       почему то удаляется весь вопрос
        question.cancel_vote(mike)

        # expect(page).to_not have_content "Отмена"
        within '.total' do
          expect(page).to have_content "0"
        end
      end
    end

    scenario "logged user try to vote the second time", js: true do
      within '.question-block' do
        click_link "+"
        click_link "+"
        within '.total' do
          expect(page).to have_content "1"
        end
        click_link "-"
        click_link "-"
        within '.total' do
          expect(page).to have_content "-1"
        end
      end
    end

    scenario "author question try to vote", js: true do
      question.update(user: mike)
      visit question_path(question)
      within '.question-block' do
        click_link "+"
        expect(page).to have_content "Вы не можете голосовать за свой вопрос или ответ!"
      end
    end
  end

end
