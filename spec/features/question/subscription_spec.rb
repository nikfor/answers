require_relative "../feature_helper"

feature "Subscriptions", %q{
  In order to receive information about new answers to the question interesting for me
  As an authenticated user
  I want to be able subscribes to the questions
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:question_subscribed) { create(:question, user: user) }

  scenario "Logged user subscribe to question", js: true do
    sign_in(user.email, user.password)
    visit question_path(question)
    click_on "Подписаться"

    expect(page).to have_content "Вы подписаны на обновления данного вопроса!"
    expect(page).to_not have_link "Подписаться"
    expect(page).to have_link "Отписаться"
  end

  scenario "Logged user unsubscribe from question", js: true do
    sign_in(user.email, user.password)
    visit question_path(question_subscribed)
    click_on "Отписаться"

    expect(page).to have_content "Вы отписаны от обновлений данного вопроса!"
    expect(page).to have_link "Подписаться"
    expect(page).to_not have_link "Отписаться"
  end

  scenario "Non logged user doesn't see subscribe buttons", js: true do
    visit question_path(question)
    expect(page).to_not have_link "Подписаться"
    expect(page).to_not have_link "Отписаться"
  end
end
