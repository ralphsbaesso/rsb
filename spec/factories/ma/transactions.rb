FactoryBot.define do

  factory :ma_transaction, class: ManagerAccount::Transaction do
    amount { 0 }
    description { 'MyString' }
    origin { 'MyString' }
    pay_date { Faker::Date.backward }
    price_cents { Faker::Number.number(digits: 5) }
    status { 'MyString' }
    transaction_date { Faker::Date.backward }
    account_user { nil }
    ma_account { nil }
    ma_item { nil }
  end
end
