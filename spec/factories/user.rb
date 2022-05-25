FactoryBot.define do
  factory :user do
    firstname {'John'}
    lastname {'Doe'}
    email { 'jon.doe@gmail.com' }
    password { 'some_password' }

    association :company
  end
end
