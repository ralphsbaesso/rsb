# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  action          :string
#  app             :string
#  details         :jsonb
#  event_type      :string
#  important       :boolean          default(FALSE)
#  message         :string
#  origin          :string
#  service         :string
#  user_email      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_events_on_account_user_id                 (account_user_id)
#  index_events_on_account_user_id_and_app         (account_user_id,app)
#  index_events_on_account_user_id_and_important   (account_user_id,important)
#  index_events_on_account_user_id_and_user_email  (account_user_id,user_email)
#

FactoryBot.define do
  factory :event do
    account_user { nil }
    rsb_module { 'MyString' }
    service { 'MyString' }
    message { 'MyString' }
    logger_type { 'MyString' }
    important { false }
    origin { 'MyString' }
    action { 'MyString' }
    details { '' }
  end
end
