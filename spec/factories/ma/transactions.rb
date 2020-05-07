FactoryBot.define do

  factory :ma_transaction, class: ManagerAccount::Transaction do
    amount { 0 }
    description { 'MyString' }
    origin { 'MyString' }
    pay_date { 'MyString' }
    price_cents { 'MyString' }
    status { 'MyString' }
    transaction_date { 'MyString' }
    account_user { nil }
    ma_account { nil }
    ma_item { nil }
    ma_subitem { nil }
  end
end
