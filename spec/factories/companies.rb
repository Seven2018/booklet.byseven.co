FactoryBot.define do
  factory :company do
    siret { '1234567890abcd' }
    applications { '{interviews,trainings,objectives}' }
  end
end
