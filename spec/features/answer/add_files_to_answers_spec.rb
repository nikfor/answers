require_relative "../feature_helper.rb"

feature "Add files to answer", %q{
  In order to illustrate my answer
  As an answer author
  I want to be able to attach file
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  background do
    sign_in(user.email, user.password)
    visit question_path(question)
  end

  scenario "user add files when he create question", js: true do
    fill_in "Ваш ответ", with: "Test answer"
    attach_file "Файл", "#{Rails.root}/spec/controllers/answers_controller_spec.rb"
    click_on "Создать"
    within ".answer" do
      expect(page).to have_link "answers_controller_spec.rb", href: "/uploads/attachment/file/1/answers_controller_spec.rb"
    end
  end
end

