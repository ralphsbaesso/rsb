# frozen_string_literal: true

# == Schema Information
#
# Table name: bam_accounts
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
#  index_bam_accounts_on_account_user_id  (account_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

class BAM::Account < ApplicationRecord
  include RuleBox::Mapper

  belongs_to :account_user
  has_many :bam_transactions, class_name: 'BAM::Transaction', foreign_key: :bam_account_id

  alias_attribute :au, :account_user
  alias_attribute :type, :account_type
  validates :name, presence: true

  rules_of_insert Strategy::Shares::CheckName,
                  Strategy::Shares::SaveModel

  rules_of_update Strategy::Shares::CheckName,
                  Strategy::Shares::SaveModel

  rules_of_delete Strategy::BAMAccounts::CheckAssociation,
                  Strategy::Shares::DestroyModel

  rules_of_select Strategy::BAMAccounts::Filter

  def as_json(options = nil)
    j = super
    j[:type] = type
    j
  end
  FIELDS = [
    {
      field: :transacted_at,
      description: 'Campo data transação'
    },
    {
      field: :paid_at,
      description: 'Campo data pagamento'
    },
    {
      field: :ignore,
      description: 'Ignorar campo'
    },
    {
      field: :value,
      description: 'Campo valor'
    },
    {
      field: :reverse_value,
      description: 'Campo valor invertido'
    },
    {
      field: :description,
      description: 'Campo descrição'
    },
    {
      field: :annotation,
      description: 'Campo extra para anotações'
    },
    {
      field: :symbol_of_value,
      description: 'Simbolo de valor'
    }
  ].freeze

  def self.find_field(field)
    FIELDS.find { |f| f == field }
  end
end
