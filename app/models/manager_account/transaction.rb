# == Schema Information
#
# Table name: ma_transactions
#
#  id               :bigint           not null, primary key
#  amount           :float            default(0.0)
#  description      :string
#  origin           :string
#  pay_date         :date
#  price_cents      :integer          default(0)
#  status           :string
#  transaction_date :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_user_id  :bigint
#  ma_account_id    :bigint
#  ma_item_id       :bigint
#  ma_subitem_id    :bigint
#
# Indexes
#
#  index_ma_transactions_on_account_user_id  (account_user_id)
#  index_ma_transactions_on_ma_account_id    (ma_account_id)
#  index_ma_transactions_on_ma_item_id       (ma_item_id)
#  index_ma_transactions_on_ma_subitem_id    (ma_subitem_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#  fk_rails_...  (ma_account_id => ma_accounts.id)
#

require_relative '../manager_account'

class ManagerAccount::Transaction < ApplicationRecord
  belongs_to :ma_item, optional: true, class_name: 'ManagerAccount::Item'
  belongs_to :ma_account, class_name: 'ManagerAccount::Account'
  belongs_to :account_user

  has_and_belongs_to_many :labels, foreign_key: :ma_transaction_id

  alias_attribute :au, :account_user
  alias_attribute :item, :ma_item
  monetize :price_cents

  def self.rules_of_insert
    [
      Strategy::MATransactions::CheckTransactionDate,
      Strategy::MATransactions::CheckPayDate,
      Strategy::MATransactions::CheckAccount,
      Strategy::Shares::SaveModel
    ]
  end

  def self.rules_of_update
    [
      Strategy::MATransactions::CheckTransactionDate,
      Strategy::MATransactions::CheckPayDate,
      Strategy::MATransactions::CheckAccount,
      Strategy::Shares::SaveModel
    ]
  end

  def self.rules_of_delete
    [
      Strategy::Shares::DestroyModel
    ]
  end

  def self.rules_of_select
    [
      Strategy::MATransactions::Filter

    ]
  end

end
