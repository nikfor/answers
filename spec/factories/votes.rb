FactoryGirl.define do

  factory :yea, class: Vote do
    user
    value 1
  end

  factory :nay, class: Vote do
    user
    value -1
  end

end
