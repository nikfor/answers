FactoryGirl.define do
  sequence :title do |n|
    "Сколько будет 2+#{n} ?"
  end

  factory :question do
    title
    body "Никак не могу понять, сколько будет 2+2, помогите с решением проблемы!"
    user
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end
end
