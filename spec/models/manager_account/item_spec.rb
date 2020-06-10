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
  let!(:ac) { create(:account_user, user: user, account: account) }

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
        item = build(:ma_item, ac: ac, name: Faker::Name.name)

        t = Facade.new(ac).insert item
        expect(t.status).to eq(:green)
        expect(MA::Item.count).to eq(1)
        expect(Event.count).to eq(0)
      end

      it "don't must save already exits name", :events do
        name = Faker::Name.name
        create(:ma_item, ac: ac, name: name)
        item = build(:ma_item, ac: ac, name: name)

        expect do
          transporter = Facade.new(ac).insert item
          expect(transporter.status).to eq(:red)
          expect(transporter.messages.count).to eq(1)
        end.to change(MA::Item, :count).by(0)

        expect(Event.count).to eq(0)
      end
    end

    context 'update' do
      it 'must update' do
        item = create(:ma_item, ac: ac, name: Faker::Name.name)
        name = Faker::Name.name
        item.name = name

        t = Facade.new(ac).update item
        expect(t.status).to eq(:green)
        expect(item.name).to eq(name)
      end
    end

    context 'delete' do
      it 'decrease one item' do

        item = create(:ma_item, ac: ac)
        expect {
          Facade.new(ac).delete(item)
        }.to change(MA::Item, :count).by(-1)

        expect(Event.count).to eq(0)
      end

      it 'return error account with association' do
        item = create(:ma_item, ac: ac)
        create(:ma_subitem, ma_item: item)

        transport = nil
        expect {
          transport = Facade.new(ac).delete(item)
        }.to change(MA::Item, :count).by(0)

        expect(transport.status).to eq(:red)
      end
    end

    context 'select' do

      it 'return list of items' do
        amount = 10
        create_list(:ma_item, amount, ac: ac)

        transporter = Facade.new(ac).select MA::Item.to_s
        expect(transporter.items.count).to eq(amount)
      end
    end

  end


end
