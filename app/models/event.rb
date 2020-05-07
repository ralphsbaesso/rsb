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

class Event < ApplicationRecord
  belongs_to :account_user

  def self.add(account_user, **arguments)
    event = self.new(account_user: account_user)

    arguments.each do |key, value|
      if event.respond_to? key
        event[key] = value
      else
        event.details[key] = value
      end
    end
    event.save
  end

  def self.application(account_user, **arguments)
    arguments[:rsb_module] = :application
    add(account_user, arguments)
  end
end
