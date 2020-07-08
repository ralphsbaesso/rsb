# == Schema Information
#
# Table name: ma_structures
#
#  id              :bigint           not null, primary key
#  fields          :jsonb
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_ma_structures_on_account_user_id  (account_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

class ManagerAccount::Structure
  belongs_to :account_user
  validates :name, uniqueness: true

  def self.add_option(type, description: nil, lambda: nil)
    options << [type, description, lambda]
  end

  def self.options
    @options ||= []
  end

  def self.description_options
    options.map { |v| [v[0], v[1]] }
  end

  add_option :transaction_date, description: 'Campo data transação', lambda: lambda { |value|
    begin
      value.to_datetime
    rescue StandardError
      nil
    end
  }

  add_option :pay_date, description: 'Campo data pagamento', lambda: lambda { |value|
    begin
      value.to_datetime
    rescue StandardError
      nil
    end
  }
  
  add_option :ignore, description: 'Ignorar campo'
  add_option :value, description: 'Campo valor', lambda: ->(v) { v }
  add_option :reverse_value, description: 'Campo valor invertido', lambda: ->(v) { v * -1 }

end
