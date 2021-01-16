# == Schema Information
#
# Table name: moment_photos
#
#  id              :bigint           not null, primary key
#  description     :string
#  metadata        :jsonb
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_moment_photos_on_account_user_id  (account_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

FactoryBot.define do
  factory :moment_photo, class: 'Moment::Photo' do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
  end
end
