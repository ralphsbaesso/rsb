# frozen_string_literal: true

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
  factory :account do
    name { Faker::FunnyName.name }
  end
end
