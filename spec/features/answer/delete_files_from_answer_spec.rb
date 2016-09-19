require_relative "../feature_helper.rb"

feature "Delete files from answer", %q{
  In order to not see unnecessary files
  As an answer author
  I want to be able to delete files from answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:file1) { create(:attachment, attachable: answer) }
  given!(:file2) { create(:attachment, attachable: answer) }

  background do
    sign_in(user.email, user.password)
  end

  scenario "user try to deletes files from own answer", js: true do
    answer.update(user: user)
    visit question_path(question)
    within ".answer" do
      expect(page).to have_link "Удалить файл", count: 2
      all('.delete_file_link')[0].click
      expect(page).to have_link "Удалить файл", count: 1
    end
  end

  scenario "user doesn't see delete file links from another user answer", js: true do
    visit question_path(question)
    within ".answer" do
      expect(page).to_not have_link "Удалить файл"
    end
  end

end

