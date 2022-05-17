FactoryBot.define do
  factory :company do
    siret { ('a'..'n').to_a.shuffle.join }
    applications { '{interviews,trainings,objectives}' }
  end
end
