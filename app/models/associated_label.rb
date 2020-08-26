# == Schema Information
#
# Table name: associated_labels
#
#  id         :bigint           not null, primary key
#  owner_type :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  label_id   :bigint
#  owner_id   :bigint
#
# Indexes
#
#  index_associated_labels_on_label_id                 (label_id)
#  index_associated_labels_on_owner_type_and_owner_id  (owner_type,owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (label_id => labels.id)
#

class AssociatedLabel < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :label
end
