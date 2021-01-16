# == Schema Information
#
# Table name: archives
#
#  id         :bigint           not null, primary key
#  content    :text
#  extension  :string
#  filename   :string
#  md5        :string
#  owner_type :string
#  size       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint
#
# Indexes
#
#  index_archives_on_owner_type_and_owner_id  (owner_type,owner_id)
#

require 'rails_helper'

RSpec.describe Archive, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
