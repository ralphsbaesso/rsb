# frozen_string_literal: true

# == Schema Information
#
# Table name: bam_accounts
#
#  id              :bigint           not null, primary key
#  account_type    :string
#  description     :string
#  fields          :jsonb
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_bam_accounts_on_account_user_id  (account_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

require 'rails_helper'

RSpec.describe BAM::Account, type: :model do
  let!(:user) { create(:user) }
  let!(:account) { create(:account) }
  let!(:au) { create(:account_user, user: user, account: account) }

  describe 'have atrributes' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:description) }
  end

  after do
    events(:error)
  end

  describe 'business rules' do
    context 'insert' do
      it 'increase one account' do
        account = build(:bam_account, au: au)
        facade = Facade.new(account_user: au)
        facade.insert(account)
        expect(facade.status).to eq(:green)
        expect(BAM::Account.count).to eq(1)
      end
    end

    context 'update' do
      it 'modify attributes' do
        account = create(:bam_account, au: au, name: Faker::Name.name)
        new_name = Faker::FunnyName.name
        new_description = Faker::Book.publisher

        account.name = new_name
        account.description = new_description
        facade = Facade.new(account_user: au)
        facade.update account
        expect(facade.status).to eq(:green)

        account.reload
        expect(account.name).to eq(new_name)
        expect(account.description).to eq(new_description)
      end

      it 'return message error update with same name' do
        name = Faker::Name.name
        create(:bam_account, au: au, name: name)
        account = create(:bam_account, au: au, name: Faker::FunnyName.name)

        account.name = name
        facade = Facade.new(account_user: au)
        facade.update account

        expect(facade.status).to eq(:red)
      end
    end

    context 'delete' do
      it 'decrease one account' do
        account = create(:bam_account, au: au)
        expect do
          Facade.new(account_user: au).delete(account)
        end.to change(BAM::Account, :count).by(-1)
      end

      it 'return error account with association' do
        account = create(:bam_account, au: au)
        create(:bam_transaction, au: au, bam_account: account)

        facade = Facade.new(account_user: au)
        expect do
          facade.delete(account)
        end.to change(Account, :count).by(0)

        expect(facade.status).to eq(:red)
      end
    end

    context 'select' do
      it 'return list of items' do
        amount = 10
        create_list(:bam_account, amount, au: au)

        facade = Facade.new(account_user: au)
        facade.select BAM::Account.to_s
        expect(facade.data.count).to eq(amount)
      end
    end
  end
end
