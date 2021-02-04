# frozen_string_literal: true

# == Schema Information
#
# Table name: bam_categories
#
#  id              :bigint           not null, primary key
#  description     :string
#  level           :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_bam_categories_on_account_user_id           (account_user_id)
#  index_bam_categories_on_account_user_id_and_name  (account_user_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

class BAM::Category < ApplicationRecord
  include RuleBox::Mapper

  belongs_to :account_user
  has_many :bam_transactions, class_name: 'BAM::Transaction', foreign_key: :bam_category_id

  alias_attribute :au, :account_user
  validates_presence_of :name, :level

  rules_of_insert Strategy::Shares::CheckName,
                  Strategy::Shares::SaveModel

  rules_of_update Strategy::Shares::CheckName,
                  Strategy::Shares::SaveModel

  rules_of_delete Strategy::BAMItems::CheckAssociation,
                  Strategy::Shares::DestroyModel

  rules_of_select Strategy::BAMCategories::Filter
end
