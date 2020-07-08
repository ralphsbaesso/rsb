# == Schema Information
#
# Table name: ma_transactions
#
#  id               :bigint           not null, primary key
#  amount           :float            default(0.0)
#  description      :string
#  origin           :string
#  pay_date         :date
#  price_cents      :integer          default(0)
#  status           :string
#  transaction_date :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_user_id  :bigint
#  ma_account_id    :bigint
#  ma_item_id       :bigint
#  ma_subitem_id    :bigint
#
# Indexes
#
#  index_ma_transactions_on_account_user_id  (account_user_id)
#  index_ma_transactions_on_ma_account_id    (ma_account_id)
#  index_ma_transactions_on_ma_item_id       (ma_item_id)
#  index_ma_transactions_on_ma_subitem_id    (ma_subitem_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#  fk_rails_...  (ma_account_id => ma_accounts.id)
#

require 'rails_helper'

RSpec.describe MA::Transaction, type: :model do
  let!(:user) { create(:user) }
  let!(:account) { create(:account) }
  let!(:au) { create(:account_user, user: user, account: account) }
  let(:ma_account) { create(:ma_account, au: au) }
  let(:item) { create(:ma_item, au: au) }

  after do
    events(:error)
  end

  context 'Save' do
    it 'increase one transaction' do
      transaction = MA::Transaction.new(
        au: au,
        ma_account: ma_account,
        transaction_date: Date.today
      )

      expect do
        transporter = facade.insert(transaction)
        expect(transporter.status_green?).to be_truthy
        expect(transaction.transaction_date).to eq(transaction.pay_date)
      end.to change(MA::Transaction, :count).by(1)
    end

    it 'increase one transaction with associations' do
      item = create(:ma_item, au: au)

      transaction = MA::Transaction.new(
        au: au,
        ma_account: ma_account,
        transaction_date: Date.today,
        item: item,
      )

      expect do
        transporter = facade.insert(transaction)
        expect(transporter.status_green?).to be_truthy
        expect(transaction.transaction_date).to eq(transaction.pay_date)
        expect(transaction.ma_item_id).to eq(item.id)
      end.to change(MA::Transaction, :count).by(1)
    end

    it "don't save with invalids fields" do
      transaction = MA::Transaction.new

      expect do
        t = facade.insert(transaction)
        expect(t.status_green?).to be_falsey
        expect(t.messages.count).to eq(2)
        expect(t.messages.first).to eq('Data da transação inválida.')
        expect(t.messages.last).to eq('Deve associar a transação ao uma Conta.')
      end.to change(MA::Transaction, :count).by(0)
    end

  end

  context 'update' do
    it 'modify attributes' do
      transaction = create(:ma_transaction, au: au, ma_account: ma_account)

      new_price = Money.new(transaction.price_cents + 1)
      new_description = Faker::Book.publisher

      transaction.price = new_price
      transaction.description = new_description

      t = facade.update transaction
      expect(t.status_green?).to be_truthy

      expect(transaction.price).to eq(new_price)
      expect(transaction.description).to eq(new_description)
    end

  end

  context 'delete' do
    it 'decrease one item' do
      transaction = create(:ma_transaction, au: au, ma_account: ma_account)

      expect do
        facade.delete(transaction)
        end.to change(MA::Transaction, :count).by(-1)
    end

  end

  context 'select' do

    it 'all' do
      size = [5, 7, 8].sample
      size.times do
        create(:ma_transaction, au: au, ma_account: ma_account)
      end

      transporter = facade.select MA::Transaction
      items = transporter.items
      expect(items.count).to eq(size)
    end

    it 'with label' do
      [2, 5, 6].sample.times do
        create(:ma_transaction, au: au, ma_account: ma_account)
      end

      transaction = MA::Transaction.all.sample
      label = build(:label, au: au)
      transaction.labels << label
      transaction.save

      transporter = facade.select MA::Transaction, filter: { label_id: label.id }
      items = transporter.items
      expect(items.count).to eq(1)
    end

  end

  def facade
    Facade.new au
  end
end
