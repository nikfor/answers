FactoryGirl.define do
  factory :attachment do
    file { File.new(File.join(Rails.root, 'config.ru')) }
  end
end
