# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Account < ApplicationRecord
end
