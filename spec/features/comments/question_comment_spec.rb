require_relative "../feature_helper.rb"

feature "Add comments to question", %{
  In order to express my opinion
  As an logged user
  I want to be able to add comments
} do

  given(:mike) { create(:user) }
  given(:question) { create(:question) }

  describe "logged user" do

    background do
      sign_in(mike.email, mike.password)
      visit question_path(question)
    end

    scenario "add comment to question", js: true do
      within ".question-block" do
        click_on "Комментировать"
        fill_in "Новый комментарий", with: "Test comment"
        click_on "Создать"
        expect(page).to have_content "Test comment"
        expect(current_path).to eq question_path(question)
      end
    end
  end


  scenario "non logged user try to create comment", js: true do
    visit question_path(question)
    within ".question-block" do
      expect(page).to_not have_content("Комментировать")
    end
  end

end
