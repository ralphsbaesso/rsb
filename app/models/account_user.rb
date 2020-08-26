# == Schema Information
#
# Table name: account_users
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_account_users_on_account_id  (account_id)
#  index_account_users_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#

class AccountUser < ApplicationRecord
  belongs_to :account
  belongs_to :user

  has_many :labels

  has_many :bam_items, class_name: 'BAM::Item'
  has_many :bam_accounts, class_name: 'BAM::Account'
  has_many :bam_transactions, class_name: 'BAM::Transaction'

  has_many :labels

end
