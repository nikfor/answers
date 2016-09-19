require_relative "../feature_helper.rb"

feature "Delete files from question", %q{
  In order to not see unnecessary files
  As an question author
  I want to be able to delete files from question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:file1) { create(:attachment, attachable: question) }
  given!(:file2) { create(:attachment, attachable: question) }

  background do
    sign_in(user.email, user.password)
  end

  scenario "user try to deletes files from own question", js: true do
    question.update(user: user)
    visit question_path(question)
    within ".question-block" do
      expect(page).to have_link "Удалить файл", count: 2
      all('.delete_file_link')[0].click
      expect(page).to have_link "Удалить файл", count: 1
    end
  end

  scenario "user doesn't see delete file links from another user question", js: true do
    visit question_path(question)
    within "<div class="question-block"></div>" do
      expect(page).to_not have_link "Удалить файл"
    end
  end

end
