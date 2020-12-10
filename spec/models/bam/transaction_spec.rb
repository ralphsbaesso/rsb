# == Schema Information
#
# Table name: bam_transactions
#
#  id              :bigint           not null, primary key
#  amount          :float            default(0.0)
#  annotation      :text
#  description     :string
#  origin          :string
#  paid_at         :date
#  price_cents     :integer          default(0)
#  status          :string
#  transacted_at   :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#  bam_account_id  :bigint
#  bam_category_id :bigint
#  bam_item_id     :bigint
#
# Indexes
#
#  index_bam_transactions_on_account_user_id  (account_user_id)
#  index_bam_transactions_on_bam_account_id   (bam_account_id)
#  index_bam_transactions_on_bam_category_id  (bam_category_id)
#  index_bam_transactions_on_bam_item_id      (bam_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#  fk_rails_...  (bam_account_id => bam_accounts.id)
#

require 'rails_helper'

RSpec.describe BAM::Transaction, type: :model do
  let!(:user) { create(:user) }
  let!(:account) { create(:account) }
  let!(:au) { create(:account_user, user: user, account: account) }
  let(:bam_account) { create(:bam_account, au: au) }
  let(:item) { create(:bam_item, au: au) }

  after do
    events(:error)
  end

  context 'Save' do
    it 'increase one transaction' do
      transaction = BAM::Transaction.new(
        au: au,
        bam_account: bam_account,
        transacted_at: Date.today
      )

      expect do
        facade = Facade.new(account_user: au)
        facade.insert(transaction)
        expect(facade.status_green?).to be_truthy
        expect(transaction.transacted_at).to eq(transaction.paid_at)
      end.to change(BAM::Transaction, :count).by(1)
    end

    it 'increase one transaction with associations' do
      item = create(:bam_item, au: au)

      transaction = BAM::Transaction.new(
        au: au,
        bam_account: bam_account,
        transacted_at: Date.today,
        item: item
      )

      expect do
        facade = Facade.new(account_user: au)
        facade.insert(transaction)
        expect(facade.status_green?).to be_truthy
        expect(transaction.transacted_at).to eq(transaction.paid_at)
        expect(transaction.bam_item_id).to eq(item.id)
      end.to change(BAM::Transaction, :count).by(1)
    end

    it "don't save with invalids fields" do
      transaction = BAM::Transaction.new

      expect do
        facade = Facade.new(account_user: au)
        facade.insert(transaction)

        expect(facade.status_green?).to be_falsey
        expect(facade.errors.count).to eq(2)
        expect(facade.errors.first).to eq('Data da transação inválida.')
        expect(facade.errors.last).to eq('Deve associar a transação ao uma Conta.')
      end.to change(BAM::Transaction, :count).by(0)
    end

  end

  context 'update' do
    it 'modify attributes' do
      transaction = create(:bam_transaction, au: au, bam_account: bam_account)

      new_price = Money.new(transaction.price_cents + 1)
      new_description = Faker::Book.publisher

      transaction.price = new_price
      transaction.description = new_description

      facade = Facade.new(account_user: au)
      facade.update transaction
      expect(facade.status_green?).to be_truthy

      expect(transaction.price).to eq(new_price)
      expect(transaction.description).to eq(new_description)
    end

  end

  context 'delete' do
    it 'decrease one item' do
      transaction = create(:bam_transaction, au: au, bam_account: bam_account)

      expect do
        facade = Facade.new(account_user: au)
        facade.delete(transaction)
        end.to change(BAM::Transaction, :count).by(-1)
    end

  end

  context 'select' do

    it 'all' do
      size = [5, 7, 8].sample
      size.times do
        create(:bam_transaction, au: au, bam_account: bam_account)
      end

      facade = Facade.new(account_user: au)
      facade.select BAM::Transaction
      expect(facade.data.count).to eq(size)
    end

    it 'with label' do
      [2, 5, 6].sample.times do
        create(:bam_transaction, au: au, bam_account: bam_account)
      end

      transaction = BAM::Transaction.all.sample
      label = build(:label, au: au)
      transaction.labels << label
      transaction.save

      facade = Facade.new(account_user: au)
      facade.select BAM::Transaction, filter: { label_id: label.id }
      expect(facade.data.count).to eq(1)
    end

    it 'by generic' do
      phrase = 'Timão subiu no ônibus em Marrocos'
      phrase1 = 'Vai timão'
      phrase2 = 'Então é NATAL.'
      [phrase, phrase1, phrase2].each do |description|
        create(:bam_transaction, au: au, bam_account: bam_account, description: description)
      end

      facade = Facade.new(account_user: au)
      facade.select BAM::Transaction, filter: { generic: 'natal' }
      expect(facade.data.count).to eq(1)

      facade = Facade.new(account_user: au)
      facade.select BAM::Transaction, filter: { generic: 'TIMÃO' }
      expect(facade.data.count).to eq(2)
    end

  end
end
