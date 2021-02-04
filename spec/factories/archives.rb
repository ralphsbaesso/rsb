# frozen_string_literal: true

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
#  index_archives_on_extension                (extension)
#  index_archives_on_filename                 (filename)
#  index_archives_on_md5                      (md5)
#  index_archives_on_owner_type_and_owner_id  (owner_type,owner_id)
#  index_archives_on_size                     (size)
#

FactoryBot.define do
  factory :archive do
  end
end
