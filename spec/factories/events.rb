# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  action          :string
#  details         :jsonb
#  event_type      :string
#  important       :boolean          default(FALSE)
#  message         :string
#  origin          :string
#  rsb_module      :string
#  service         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_events_on_account_user_id  (account_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

FactoryBot.define do
  factory :event do
    account_user { nil }
    rsb_module { "MyString" }
    service { "MyString" }
    message { "MyString" }
    logger_type { "MyString" }
    important { false }
    origin { "MyString" }
    action { "MyString" }
    details { "" }
  end
end
