require_relative "../feature_helper.rb"

feature 'Add files to question', %q{
  In order to illustrate my question
  As an logged question author
  I'd like to be able to attach files
} do

  given!(:user) { create(:user) }

  background do
    sign_in(user.email, user.password)
    visit new_question_path
  end

  scenario "user add files when he create question" do
    fill_in "Заголовок", with: "What?"
    fill_in "Вопрос", with: "What? What? What? Abcdf Test"
    attach_file "Файл", "#{Rails.root}/spec/controllers/answers_controller_spec.rb"
    click_on "Создать"

    expect(page).to have_link "answers_controller_spec.rb", href: "/uploads/attachment/file/1/answers_controller_spec.rb"
  end
end
