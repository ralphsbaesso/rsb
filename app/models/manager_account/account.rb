# == Schema Information
#
# Table name: ma_accounts
#
#  id              :bigint           not null, primary key
#  description     :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_ma_accounts_on_account_user_id  (account_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

class ManagerAccount::Account < ApplicationRecord
  belongs_to :account_user
  has_many :ma_transactions, class_name: 'ManagerAccount::Transaction', foreign_key: :ma_account_id

  alias_attribute :ac, :account_user
  validates_presence_of :name

  def self.rules_of_insert
    [
      Strategy::Shares::CheckName,
      Strategy::Shares::SaveModel
    ]
  end

  def self.rules_of_update
    [
      Strategy::Shares::CheckName,
      Strategy::Shares::SaveModel
    ]
  end

  def self.rules_of_delete
    [
      Strategy::MAAccounts::CheckAssociation,
      Strategy::Shares::DestroyModel
    ]
  end

  def self.rules_of_select
    [
      Strategy::MAAccounts::Filter

    ]
  end

end
