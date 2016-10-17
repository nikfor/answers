require_relative "../feature_helper.rb"

feature 'Add files to question', %q{
  In order to illustrate my question
  As an logged question author
  I'd like to be able to attach files
} do

  given!(:user) { create(:user) }

  background do
    sign_in(user.email, user.password)
    visit questions_path
    click_on "Задать вопрос"
  end

  scenario "user add files when he create question", js: true do
    fill_in "Заголовок", with: "What?"
    fill_in "Вопрос", with: "What? What? What? Abcdf Test"
    click_on "добавить файл"
    attach_file "Файл", "#{Rails.root}/spec/controllers/answers_controller_spec.rb"
    click_on "Создать"
    visit questions_path
    click_on "What?"

    expect(page).to have_link "answers_controller_spec.rb", href: "/uploads/attachment/file/1/answers_controller_spec.rb"
  end
end
