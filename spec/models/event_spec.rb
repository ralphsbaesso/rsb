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
#  user_email      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_events_on_account_user_id                 (account_user_id)
#  index_events_on_account_user_id_and_important   (account_user_id,important)
#  index_events_on_account_user_id_and_rsb_module  (account_user_id,rsb_module)
#  index_events_on_account_user_id_and_user_email  (account_user_id,user_email)
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
