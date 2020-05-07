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
end
