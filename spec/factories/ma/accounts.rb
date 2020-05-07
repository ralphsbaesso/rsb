# == Schema Information
#
# Table name: accounts
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do

  factory :ma_account, class: ManagerAccount::Account do
    name { Faker::FunnyName.name }
    description { Faker::Lorem.paragraph }
    account_user { nil }
  end
end
