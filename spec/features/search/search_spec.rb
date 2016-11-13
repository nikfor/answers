require_relative "sphinx_helper.rb"

feature "Searching", %{
  In order to search interested information
  As an user
  I want to be able search questions or comments or answers
} do

  given!(:mike) { create(:user) }
  given!(:question) { create(:question, title: "testing question") }
  given!(:question2) { create(:question, title: "aabbcc") }
  given!(:answer) { create(:answer, body: "aabbcc") }
  given!(:comment) { create(:comment, body: "good comment") }
  given!(:comment2) { create(:comment, body: "aabbcc") }

  background do
    visit root_path(question)
  end

  scenario "search question", sphinx: true do
    ThinkingSphinx::Test.run do
      click_on "Поиск"
      choose("Искать в вопросах")
      fill_in "Введите слово или фразу:", with: question.title
      click_on "Искать"

      expect(page).to have_content question.title
      expect(page).to_not have_content question2.title
      expect(current_path).to eq search_path
    end
  end

  scenario "search answer", sphinx: true do
    ThinkingSphinx::Test.run do
      click_on "Поиск"
      choose("Искать в ответах")
      fill_in "Введите слово или фразу:", with: answer.body
      click_on "Искать"

      expect(page).to have_content answer.body
      expect(current_path).to eq search_path
    end
  end

  scenario "search comment", sphinx: true do
    ThinkingSphinx::Test.run do
      click_on "Поиск"
      choose("Искать в комментариях")
      fill_in "Введите слово или фразу:", with: comment.body
      click_on "Искать"

      expect(page).to have_content comment.body
      expect(current_path).to eq search_path
    end
  end

   scenario "search all", sphinx: true do
    ThinkingSphinx::Test.run do
      click_on "Поиск"
      choose("Искать везде")
      fill_in "Введите слово или фразу:", with: "aabbcc"
      click_on "Искать"

      expect(page).to have_content("aabbcc", count: 3)
      expect(current_path).to eq search_path
    end
  end

  scenario "doesn't search not exist information", sphinx: true do
    ThinkingSphinx::Test.run do
      click_on "Поиск"
      choose("Искать везде")
      fill_in "Введите слово или фразу:", with: "lsakcblahbcjhaskcjh"
      click_on "Искать"

      expect(page).to have_content "Ни одного совпадения!"
      expect(current_path).to eq search_path
    end
  end
end
