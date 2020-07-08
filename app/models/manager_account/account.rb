# == Schema Information
#
# Table name: ma_accounts
#
#  id              :bigint           not null, primary key
#  account_type    :string
#  description     :string
#  fields          :jsonb
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

  alias_attribute :au, :account_user
  validates_presence_of :name
  alias_attribute :type, :account_type

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

  class Struct

    def self.description_options
      options.map { |option| [option[:field], option[:description]] }
    end

    def self.find_field(field)
      options.find { |f| f == field }
    end

    def self.options
      [
        {
          field: :transaction_date,
          description: 'Campo data transação',
        },
        {
          field: :pay_date,
          description: 'Campo data pagamento',
        },
        {
          field: :ignore,
          description: 'Ignorar campo'
        },
        {
          field: :value,
          description: 'Campo valor',
        },
        {
          field: :reverse_value,
          description: 'Campo valor invertido',
        },
        {
          field: :description,
          description: 'Campo descrição'
        },
        {
          field: :symbol_of_value,
          description: 'Simbolo de valor'
        }
      ]
    end

  end

end
