# == Schema Information
#
# Table name: ma_items
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
#  index_ma_items_on_account_user_id  (account_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

require 'rails_helper'

RSpec.describe ManagerAccount::Item, type: :model do
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
        item = build(:ma_item, au: au, name: Faker::Name.name)

        facade = Facade.new(account_user: au)
        facade.insert item
        expect(facade.status).to eq(:green)
        expect(MA::Item.count).to eq(1)
        expect(Event.count).to eq(0)
      end

      it "don't must save already exits name", :events do
        name = Faker::Name.name
        create(:ma_item, au: au, name: name)
        item = build(:ma_item, au: au, name: name)

        expect do
          facade = Facade.new(account_user: au)
          facade.insert item
          expect(facade.status).to eq(:red)
          expect(facade.errors.count).to eq(1)
        end.to change(MA::Item, :count).by(0)

        expect(Event.count).to eq(0)
      end
    end

    context 'update' do
      it 'must update' do
        item = create(:ma_item, au: au, name: Faker::Name.name)
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

        item = create(:ma_item, au: au)
        expect {
          Facade.new(account_user: au).delete(item)
        }.to change(MA::Item, :count).by(-1)

        expect(Event.count).to eq(0)
      end

      it 'return error account with association' do
        item = create(:ma_item, au: au)

        ma_account = create(:ma_account, au: au)
        create(:ma_transaction, au: au, ma_item: item, ma_account: ma_account)
        expect {
          facade = Facade.new(account_user: au)
          facade.delete(item)
          expect(facade.status).to eq(:red)
        }.to change(MA::Item, :count).by(0)

        expect(Event.count).to eq(0)
      end
    end

    context 'select' do

      it 'return list of items' do
        amount = 10
        create_list(:ma_item, amount, au: au)
        facade = Facade.new(account_user: au)
        facade.select MA::Item.to_s
        expect(facade.data.count).to eq(amount)
      end
    end

  end


end
