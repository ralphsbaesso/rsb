# == Schema Information
#
# Table name: labels
#
#  id               :bigint           not null, primary key
#  app              :string
#  background_color :string
#  color            :string
#  name             :string
#  original_name    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_user_id  :bigint
#
# Indexes
#
#  index_labels_on_account_user_id                   (account_user_id)
#  index_labels_on_account_user_id_and_app_and_name  (account_user_id,app,name)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

FactoryBot.define do
  factory :label do
    name { "MyString" }
    original_name { "MyString" }
    color { "MyString" }
    app { "MyString" }
    account_user { nil }
  end
end
