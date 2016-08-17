FactoryGirl.define do
  factory :question do
    title "Сколько будет 2+2 ?"
    body "Никак не могу понять, сколько будет 2+2, помогите с решением проблемы!"
  end

  factory :invalid_question, class: Question do
    title nil
    body "Никак не могу понять, сколько будет 2+2, помогите с решением проблемы!"
  end
end
