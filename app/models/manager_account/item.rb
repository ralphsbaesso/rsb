# == Schema Information
#
# Table name: ma_items
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
#  index_ma_items_on_account_user_id  (account_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

class ManagerAccount::Item < ApplicationRecord
  include RFacade::Mapper

  belongs_to :account_user
  has_many :ma_transactions, class_name: 'ManagerAccount::Transaction', foreign_key: :ma_item_id

  alias_attribute :au, :account_user
  validates_presence_of :name

  rules_of_insert Strategy::Shares::CheckName,
                  Strategy::Shares::SaveModel

  rules_of_update Strategy::Shares::CheckName,
                  Strategy::Shares::SaveModel

  rules_of_delete Strategy::MAItems::CheckAssociation,
                  Strategy::Shares::DestroyModel

  rules_of_select Strategy::MAItems::Filter

end
