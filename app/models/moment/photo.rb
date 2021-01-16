# == Schema Information
#
# Table name: moment_photos
#
#  id              :bigint           not null, primary key
#  description     :string
#  metadata        :jsonb
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_moment_photos_on_account_user_id  (account_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

class Moment::Photo < ApplicationRecord
  attr_accessor :current_archive

  include HasLabels
  include HasArchive
  include RuleBox::Mapper

  belongs_to :account_user
  alias_attribute :au, :account_user

  rules_of_insert Strategy::MomentPhotos::CheckArchive,
                  Strategy::Shares::SaveModel

  rules_of_update Strategy::Shares::SaveModel
  rules_of_select Strategy::MomentPhotos::Filter
  rules_of_delete Strategy::Shares::DestroyModel
end
