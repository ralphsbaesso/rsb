# frozen_string_literal: true

# == Schema Information
#
# Table name: bam_transactions
#
#  id              :bigint           not null, primary key
#  amount          :float            default(0.0)
#  annotation      :text
#  boolean         :boolean          default(FALSE)
#  description     :string
#  ignore          :boolean          default(FALSE)
#  origin          :string
#  paid_at         :date
#  price_cents     :integer          default(0)
#  status          :string
#  transacted_at   :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#  bam_account_id  :bigint
#  bam_category_id :bigint
#  bam_item_id     :bigint
#
# Indexes
#
#  index_bam_transactions_on_account_user_id  (account_user_id)
#  index_bam_transactions_on_bam_account_id   (bam_account_id)
#  index_bam_transactions_on_bam_category_id  (bam_category_id)
#  index_bam_transactions_on_bam_item_id      (bam_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#  fk_rails_...  (bam_account_id => bam_accounts.id)
#

class BAM::Transaction < ApplicationRecord
  include RuleBox::Mapper
  include HasLabels

  belongs_to :account_user
  belongs_to :bam_item, optional: true, class_name: 'BAM::Item'
  belongs_to :bam_category, optional: true, class_name: 'BAM::Category'

  belongs_to :bam_account, class_name: 'BAM::Account'

  has_many_attached :attaches

  alias_attribute :au, :account_user
  alias_attribute :item, :bam_item
  alias_attribute :category, :bam_category
  monetize :price_cents, disable_validation: true

  rules_of_insert Strategy::BAMTransactions::CheckTransactionDate,
                  Strategy::BAMTransactions::CheckPayDate,
                  Strategy::BAMTransactions::CheckAccount,
                  Strategy::Shares::SaveModel

  rules_of_update Strategy::BAMTransactions::CheckTransactionDate,
                  Strategy::BAMTransactions::CheckPayDate,
                  Strategy::BAMTransactions::CheckAccount,
                  Strategy::Shares::SaveModel

  rules_of_delete Strategy::Shares::DestroyModel

  rules_of_select Strategy::BAMTransactions::Filter,
                  Strategy::Shares::SelectSql,
                  Strategy::Shares::OrderBy
  # Strategy::BAMTransactions::Analytic

  def as_json(options = nil)
    j = super
    j['price'] = price.to_f
    j
  end

  def files
    attaches.map do |file|
      {
        filename: file.filename,
        byte_size: file.byte_size,
        content_type: file.content_type,
        url: public_url(file)
      }
    end
  end
end
