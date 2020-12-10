require 'rails_helper'

RSpec.describe BAM::UploadToTransaction, type: :model do
  let!(:user) { create(:user) }
  let!(:account) { create(:account) }
  let!(:au) { create(:account_user, user: user, account: account) }
  let(:bam_account) { create(:bam_account, au: au) }
  let(:item) { create(:bam_item, au: au) }

  after do
    events(:error)
  end

  context 'Save' do

    context 'account itau_cc' do
      it 'save 35 transaction' do
        bam_account.fields = %w[transacted_at description value]
        bam_account.save

        path = File.join(Rails.root, 'spec', 'files', 'bam', 'extrato_mar2019.txt')
        upload = BAM::UploadToTransaction.new(bam_account: bam_account, file: path)

        facade = Facade.new(account_user: au)
        facade.insert(upload)
        expect(BAM::Transaction.count).to eq(35)
      end

      it 'must return error' do
        path = File.join(Rails.root, 'spec', 'files', 'bam', 'extrato_mar2019.txt')
        upload = BAM::UploadToTransaction.new(bam_account: bam_account, file: path)

        facade = Facade.new(account_user: au)
        facade.insert(upload)
        expect(facade.status_green?).to be_falsey
        expect(facade.errors.first).to eq('A conta não está configurada para fazer upload de arquivos.')
        expect(BAM::Transaction.count).to eq(0)
      end

      it 'save 33 transaction' do
        bam_account.fields = %w[transacted_at description value]
        bam_account.save

        create(:bam_transaction,
               transacted_at: Date.parse('2019-03-29'),
               description: '[RSHOP-SHIBATA H 0-29/03]',
               price_cents: -14_202,
               bam_account: bam_account,
               account_user: au)

        create(:bam_transaction,
               transacted_at: Date.parse('2019-03-29'),
               description: '[RSHOP-ASSAI ATACA-29/03]',
               price_cents: -139_21,
               bam_account: bam_account,
               account_user: au)

        path = File.join(Rails.root, 'spec', 'files', 'bam', 'extrato_mar2019.txt')
        upload = BAM::UploadToTransaction.new(bam_account: bam_account, file: path)

        expect do
          facade = Facade.new(account_user: au)
          facade.insert(upload)
        end.to change(bam_account.bam_transactions, :count).by(33)
      end
    end

    context 'account "cartão de crédito santander"' do

      it 'save 18 transaction' do
        bam_account.fields = %w[transacted_at description ignore reverse_value]
        bam_account.type = :credit_card
        bam_account.save

        date = Date.new
        path = File.join(Rails.root, 'spec', 'files', 'bam', 'cartao_de_credito_santander.csv')
        upload = BAM::UploadToTransaction.new(bam_account: bam_account, file: path, paid_at: date)

        facade = Facade.new(account_user: au)
        facade.insert(upload)
        expect(bam_account.bam_transactions.count).to eq(18)

        transaction = bam_account.bam_transactions.last
        expect(transaction.price_cents).to eq(-4768)
        expect(transaction.price.format).to eq('R$ -47,68')
        expect(transaction.transacted_at).to eq(Date.new(2019, 3, 28))
        expect(transaction.paid_at).to eq(date)
      end

      it 'save 16 transaction' do
        bam_account.fields = %w[transacted_at description ignore reverse_value]
        bam_account.type = :credit_card
        bam_account.save

        create(:bam_transaction,
               transacted_at: Date.new(2018, 11, 23),
               description: '[LOJAS AMERICANAS MOG(05/08)]',
               price_cents: -1817,
               bam_account: bam_account,
               account_user: au)
        create(:bam_transaction,
               transacted_at: Date.new(2019, 3, 20),
               description: '[PERNAMBUCANAS]',
               price_cents: -4996,
               bam_account: bam_account,
               account_user: au)

        date = Date.new
        path = File.join(Rails.root, 'spec', 'files', 'bam', 'cartao_de_credito_santander.csv')
        upload = BAM::UploadToTransaction.new(bam_account: bam_account, file: path, paid_at: date)

        expect do
          facade = Facade.new(account_user: au)
          facade.insert(upload)
        end.to change(bam_account.bam_transactions, :count).by(16)

      end
    end

    context 'date_description_value' do

      it 'save 35 transaction' do
        bam_account.fields = %w[transacted_at description value]
        bam_account.save

        path = File.join(
          Rails.root, 'spec', 'files', 'bam', 'date_description_value.csv'
        )
        upload = BAM::UploadToTransaction.new(bam_account: bam_account, file: path)

        facade = Facade.new(account_user: au)
        facade.insert(upload)
        expect(bam_account.bam_transactions.count).to eq(32)
      end

      it 'save 33 transaction' do
        bam_account.fields = %w[transacted_at description value]
        bam_account.save

        create(:bam_transaction,
               transacted_at: Date.parse('2019-04-22'),
               description: '[COMPRA CARTAO - COMPRA no estabelecimento DEIA MELO REST E PIZZA M]',
               price_cents: -24_00,
               bam_account: bam_account,
               account_user: au)
        create(:bam_transaction,
               transacted_at: Date.parse('2019-05-03'),
               description: '[COMPRA CARTAO - COMPRA no estabelecimento SHIBATA H 02           M]',
               price_cents: -126_72,
               bam_account: bam_account,
               account_user: au)

        path = File.join(
          Rails.root, 'spec', 'files', 'bam', 'date_description_value.csv'
        )

        upload = BAM::UploadToTransaction.new(bam_account: bam_account, file: path)
        expect do
          facade = Facade.new(account_user: au)
          facade.insert(upload)
        end.to change(bam_account.bam_transactions, :count).by(30)
      end

      xit 'must save one and ignore two transactions' do
        account.ignore_descriptions = "ignorar\n ; SALDO ANTERIOR\n"
        bs = create(:bank_statement, accountant: accountant, account: account)
        path = File.join(Rails.root, 'spec', 'files', 'date_description_value2.csv')
        bs.last_extract.attach(io: File.open(path), filename: 'test')

        facade = Facade.new(account_user: au)
        facade.insert(bs)

        expect(bs.transactions.count).to eq(3)
        expect(bs.transactions.sample).to a_kind_of(Transaction)
        expect(bs.transactions.delete_if {|t| t.ignore? }.count).to eq(1)
      end

    end

    context 'ignore_date_doc_description_value_symbol' do
      it 'save 4 transaction' do
        bam_account.fields = %w[ignore transacted_at ignore description value symbol]
        bam_account.save

        path = File.join(
          Rails.root, 'spec', 'files', 'bam',
          'ignore_date_doc_description_value_symbol.txt'
        )

        upload = BAM::UploadToTransaction.new(bam_account: bam_account, file: path)
        facade = Facade.new(account_user: au)
        facade.insert(upload)
        expect(bam_account.bam_transactions.count).to eq(4)

        transactions = BAM::Transaction.all.to_a
        expect(transactions[0].price_cents).to eq(- 676_37)
        expect(transactions[1].price_cents).to eq(- 25_00)
        expect(transactions[2].price_cents).to eq(700_00)
        expect(transactions[3].price_cents).to eq(- 677_92)
      end
    end

  end

end
