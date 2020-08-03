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

class Event < ApplicationRecord
  belongs_to :account_user, optional: true
  
  alias_attribute :type, :event_type
  alias_attribute :module, :rsb_module

  def self.add(message:, rsb_module:, account_user: nil, type: nil, action: nil, important: nil, **detail)
    account_user = account_user.is_a?(AccountUser) ? account_user : AccountUser.find_by(id: account_user) if account_user
    user_email = detail[:user_mail] || account_user&.user&.email
    action = %i[insert delete update list].include?(action) ? action : :any

    create!(
      message: message,
      rsb_module: rsb_module,
      account: account,
      user: user,
      user_email: user_email,
      event_type: type,
      action: action,
      important: important.present?,
      detail: detail.as_json,
      metadata: metadata
    )
  rescue StandardError => e
    e
  end

  def self.add!(message:, rsb_module:, account: nil, user: nil, type: nil, action: nil, important: nil, **detail)
    data = add message: message,
               rsb_module: rsb_module,
               account: account,
               user: user,
               type: type,
               action: action,
               important: important,
               detail: detail

    data.is_a?(Event) ? data : raise(data)
  end
end
