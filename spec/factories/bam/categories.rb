# == Schema Information
#
# Table name: bam_categories
#
#  id              :bigint           not null, primary key
#  description     :string
#  level           :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_bam_categories_on_account_user_id           (account_user_id)
#  index_bam_categories_on_account_user_id_and_name  (account_user_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

FactoryBot.define do
  factory :bam_category, class: 'BAM::Category' do
    name { Faker::Name.name }
    level { %i[high medium slow].sample }
    description { Faker::Lorem.paragraph }
  end
end
