require 'rails_helper'

RSpec.describe MA::UploadToTransaction, type: :model do
  let!(:user) { create(:user) }
  let!(:account) { create(:account) }
  let!(:au) { create(:account_user, user: user, account: account) }
  let(:ma_account) { create(:ma_account, au: au) }
  let(:item) { create(:ma_item, au: au) }

  after do
    events(:error)
  end

  context 'Save' do

    context 'account itau_cc' do
      it 'save 35 transaction' do
        ma_account.fields = %w[transaction_date description value]
        ma_account.save

        path = File.join(Rails.root, 'spec', 'files', 'manager_account', 'extrato_mar2019.txt')
        upload = MA::UploadToTransaction.new(ma_account: ma_account, file: path)

        facade.insert(upload)
        expect(MA::Transaction.count).to eq(35)
      end

      it 'must return error' do
        path = File.join(Rails.root, 'spec', 'files', 'manager_account', 'extrato_mar2019.txt')
        upload = MA::UploadToTransaction.new(ma_account: ma_account, file: path)

        transporter = facade.insert(upload)
        expect(transporter.status_green?).to be_falsey
        expect(transporter.messages.first).to eq('A conta não está configurada para fazer upload de arquivos.')
        expect(MA::Transaction.count).to eq(0)
      end

      it 'save 33 transaction' do
        ma_account.fields = %w[transaction_date description value]
        ma_account.save

        create(:ma_transaction,
               transaction_date: Date.parse('2019-03-29'),
               description: '[RSHOP-SHIBATA H 0-29/03]',
               price_cents: -14_202,
               ma_account: ma_account,
               account_user: au)

        create(:ma_transaction,
               transaction_date: Date.parse('2019-03-29'),
               description: '[RSHOP-ASSAI ATACA-29/03]',
               price_cents: -139_21,
               ma_account: ma_account,
               account_user: au)

        path = File.join(Rails.root, 'spec', 'files', 'manager_account', 'extrato_mar2019.txt')
        upload = MA::UploadToTransaction.new(ma_account: ma_account, file: path)

        expect do
          facade.insert(upload)
        end.to change(ma_account.ma_transactions, :count).by(33)
      end
    end

    context 'account "cartão de crédito santander"' do

      it 'save 18 transaction' do
        ma_account.fields = %w[transaction_date description ignore reverse_value]
        ma_account.type = :credit_card
        ma_account.save

        date = Date.new
        path = File.join(Rails.root, 'spec', 'files', 'manager_account', 'cartao_de_credito_santander.csv')
        upload = MA::UploadToTransaction.new(ma_account: ma_account, file: path, pay_date: date)

        facade.insert(upload)
        expect(ma_account.ma_transactions.count).to eq(18)

        transaction = ma_account.ma_transactions.last
        expect(transaction.price_cents).to eq(-4768)
        expect(transaction.price.format).to eq('R$ -47,68')
        expect(transaction.transaction_date).to eq(Date.new(2019, 3, 28))
        expect(transaction.pay_date).to eq(date)
      end

      it 'save 16 transaction' do
        ma_account.fields = %w[transaction_date description ignore reverse_value]
        ma_account.type = :credit_card
        ma_account.save

        create(:ma_transaction,
               transaction_date: Date.new(2018, 11, 23),
               description: '[LOJAS AMERICANAS MOG(05/08)]',
               price_cents: -1817,
               ma_account: ma_account,
               account_user: au)
        create(:ma_transaction,
               transaction_date: Date.new(2019, 3, 20),
               description: '[PERNAMBUCANAS]',
               price_cents: -4996,
               ma_account: ma_account,
               account_user: au)

        date = Date.new
        path = File.join(Rails.root, 'spec', 'files', 'manager_account', 'cartao_de_credito_santander.csv')
        upload = MA::UploadToTransaction.new(ma_account: ma_account, file: path, pay_date: date)

        expect do
          facade.insert(upload)
        end.to change(ma_account.ma_transactions, :count).by(16)

      end
    end

    context 'date_description_value' do

      it 'save 35 transaction' do
        ma_account.fields = %w[transaction_date description value]
        ma_account.save

        path = File.join(
          Rails.root, 'spec', 'files', 'manager_account', 'date_description_value.csv'
        )
        upload = MA::UploadToTransaction.new(ma_account: ma_account, file: path)

        facade.insert(upload)
        expect(ma_account.ma_transactions.count).to eq(32)
      end

      it 'save 33 transaction' do
        ma_account.fields = %w[transaction_date description value]
        ma_account.save

        create(:ma_transaction,
               transaction_date: Date.parse('2019-04-22'),
               description: '[COMPRA CARTAO - COMPRA no estabelecimento DEIA MELO REST E PIZZA M]',
               price_cents: -24_00,
               ma_account: ma_account,
               account_user: au)
        create(:ma_transaction,
               transaction_date: Date.parse('2019-05-03'),
               description: '[COMPRA CARTAO - COMPRA no estabelecimento SHIBATA H 02           M]',
               price_cents: -126_72,
               ma_account: ma_account,
               account_user: au)

        path = File.join(
          Rails.root, 'spec', 'files', 'manager_account', 'date_description_value.csv'
        )

        upload = MA::UploadToTransaction.new(ma_account: ma_account, file: path)
        expect do
          facade.insert(upload)
        end.to change(ma_account.ma_transactions, :count).by(30)
      end

      xit 'must save one and ignore two transactions' do
        account.ignore_descriptions = "ignorar\n ; SALDO ANTERIOR\n"
        bs = create(:bank_statement, accountant: accountant, account: account)
        path = File.join(Rails.root, 'spec', 'files', 'date_description_value2.csv')
        bs.last_extract.attach(io: File.open(path), filename: 'test')

        facade.insert(bs)

        expect(bs.transactions.count).to eq(3)
        expect(bs.transactions.sample).to a_kind_of(Transaction)
        expect(bs.transactions.delete_if {|t| t.ignore? }.count).to eq(1)
      end

    end

    context 'ignore_date_doc_description_value_symbol' do
        it 'save 4 transaction' do
          ma_account.fields = %w[ignore transaction_date ignore description value symbol]
          ma_account.save

          path = File.join(
            Rails.root, 'spec', 'files', 'manager_account',
            'ignore_date_doc_description_value_symbol.txt'
          )

          upload = MA::UploadToTransaction.new(ma_account: ma_account, file: path)
          facade.insert(upload)
          expect(ma_account.ma_transactions.count).to eq(4)

          transactions = MA::Transaction.all.to_a
          expect(transactions[0].price_cents).to eq(- 676_37)
          expect(transactions[1].price_cents).to eq(- 25_00)
          expect(transactions[2].price_cents).to eq(700_00)
          expect(transactions[3].price_cents).to eq(- 677_92)
        end

      end

  end

  def facade
    Facade.new au
  end
end
