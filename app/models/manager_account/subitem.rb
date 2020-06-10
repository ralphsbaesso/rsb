# == Schema Information
#
# Table name: ma_subitems
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ma_item_id  :bigint
#
# Indexes
#
#  index_ma_subitems_on_ma_item_id  (ma_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (ma_item_id => ma_items.id)
#

class ManagerAccount::Subitem < ApplicationRecord
  belongs_to :ma_item, class_name: 'ManagerAccount::Item'

  alias_attribute :item, :ma_item
  alias_attribute :item_id, :ma_item_id
  validates_presence_of :name

  def self.rules_of_insert
    [
      Strategy::MASubitems::CheckItem,
      Strategy::MASubitems::CheckName,
      Strategy::Shares::SaveModel
    ]
  end

  def self.rules_of_update
    [
      Strategy::MASubitems::CheckName,
      Strategy::Shares::SaveModel
    ]
  end

  def self.rules_of_delete
    [
      Strategy::MASubitems::CheckAssociation,
      Strategy::Shares::DestroyModel
    ]
  end

  def self.rules_of_select
    [
      Strategy::MASubitems::Filter

    ]
  end
end
