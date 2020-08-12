FactoryBot.define do

  factory :bam_transaction, class: BAM::Transaction do
    amount { 0 }
    description { 'MyString' }
    origin { 'MyString' }
    pay_date { Faker::Date.backward }
    price_cents { Faker::Number.number(digits: 5) }
    status { 'MyString' }
    transaction_date { Faker::Date.backward }
    account_user { nil }
    bam_account { nil }
    bam_item { nil }
  end
end
