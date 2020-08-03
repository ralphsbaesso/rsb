# == Schema Information
#
# Table name: labels
#
#  id               :bigint           not null, primary key
#  app              :string
#  background_color :string
#  color            :string
#  name             :string
#  original_name    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_user_id  :bigint
#
# Indexes
#
#  index_labels_on_account_user_id                   (account_user_id)
#  index_labels_on_account_user_id_and_app_and_name  (account_user_id,app,name)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

class Label < ApplicationRecord
  include RFacade::Mapper
  belongs_to :account_user
  alias_attribute :au, :account_user

  rules_of_insert Strategy::Labels::CheckApp,
                  Strategy::Labels::SetName,
                  Strategy::Labels::CheckExits,
                  Strategy::Shares::SaveModel

end
