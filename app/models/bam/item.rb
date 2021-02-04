# frozen_string_literal: true

# == Schema Information
#
# Table name: bam_items
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
#  index_bam_items_on_account_user_id  (account_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

class BAM::Item < ApplicationRecord
  include RuleBox::Mapper

  belongs_to :account_user
  has_many :bam_transactions, class_name: 'BAM::Transaction', foreign_key: :bam_item_id

  alias_attribute :au, :account_user
  validates_presence_of :name

  rules_of_insert Strategy::Shares::CheckName,
                  Strategy::Shares::SaveModel

  rules_of_update Strategy::Shares::CheckName,
                  Strategy::Shares::SaveModel

  rules_of_delete Strategy::BAMItems::CheckAssociation,
                  Strategy::Shares::DestroyModel

  rules_of_select Strategy::BAMItems::Filter
end
