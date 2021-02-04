# frozen_string_literal: true

# == Schema Information
#
# Table name: bam_items
#
#  id              :bigint           not null, primary key
#  description     :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_bam_items_on_account_user_id  (account_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

require 'rails_helper'

RSpec.describe BAM::Item, type: :model do
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
      it 'must save' do
        item = build(:bam_item, au: au, name: Faker::Name.name)

        facade = Facade.new(account_user: au)
        facade.insert item
        expect(facade.status).to eq(:green)
        expect(BAM::Item.count).to eq(1)
        expect(Event.count).to eq(0)
      end

      it "don't must save already exits name", :events do
        name = Faker::Name.name
        create(:bam_item, au: au, name: name)
        item = build(:bam_item, au: au, name: name)

        expect do
          facade = Facade.new(account_user: au)
          facade.insert item
          expect(facade.status).to eq(:red)
          expect(facade.errors.count).to eq(1)
        end.to change(BAM::Item, :count).by(0)

        expect(Event.count).to eq(0)
      end
    end

    context 'update' do
      it 'must update' do
        item = create(:bam_item, au: au, name: Faker::Name.name)
        name = Faker::Name.name
        item.name = name
        facade = Facade.new(account_user: au)
        facade.update item
        expect(facade.status).to eq(:green)
        expect(item.name).to eq(name)
      end
    end

    context 'delete' do
      it 'decrease one item' do
        item = create(:bam_item, au: au)
        expect do
          Facade.new(account_user: au).delete(item)
        end.to change(BAM::Item, :count).by(-1)

        expect(Event.count).to eq(0)
      end

      it 'return error account with association' do
        item = create(:bam_item, au: au)

        bam_account = create(:bam_account, au: au)
        create(:bam_transaction, au: au, bam_item: item, bam_account: bam_account)
        expect do
          facade = Facade.new(account_user: au)
          facade.delete(item)
          expect(facade.status).to eq(:red)
        end.to change(BAM::Item, :count).by(0)

        expect(Event.count).to eq(0)
      end
    end

    context 'select' do
      it 'return list of items' do
        amount = 10
        create_list(:bam_item, amount, au: au)
        facade = Facade.new(account_user: au)
        facade.select BAM::Item.to_s
        expect(facade.data.count).to eq(amount)
      end
    end
  end
end
