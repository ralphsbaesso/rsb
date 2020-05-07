FactoryBot.define do

  factory :ma_subitem, class: ManagerAccount::Subitem do
    name { Faker::FunnyName.name }
    description { Faker::Lorem.paragraph }
    ma_item { nil }
  end
end