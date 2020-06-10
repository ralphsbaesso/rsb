require 'rails_helper'

RSpec.describe ManagerAccount::Subitem, type: :model do

  describe 'have atrributes' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:description) }
  end

  let!(:user) { create(:user) }
  let!(:account) { create(:account) }
  let!(:ac) { create(:account_user, user: user, account: account) }
  let(:item) { create(:ma_item, ac: ac) }

  after do
    events(:error)
  end

  context 'Save' do
    it 'increase one item' do

      subitem = build(:ma_subitem, ma_item: item)
      expect {
        facade.insert(subitem)
      }.to change(MA::Subitem, :count).by(1)
    end

    it 'not save if name already existing' do
      name = Faker::FunnyName.name
      create(:ma_subitem, item: item, name: name)
      subitem = build(:ma_subitem, item: item, name: name)
      expect {
        transporter = facade.insert(subitem)
        expect(transporter.status_green?).to be_falsey
      }.to change(MA::Subitem, :count).by(0)
    end

    it 'must validate "item_id"' do
      subitem = build(:ma_subitem)
      expect {
        transporter = facade.insert(subitem)
        expect(transporter.status_green?).to be_falsey
        expect(transporter.messages.first).to eq('Deve associar a um Item.')
      }.to change(MA::Subitem, :count).by(0)

    end
  end

  context 'update' do
    let!(:subitem) { create(:ma_subitem, item: item) }

    it 'modify attributes' do
      name = Faker::Name.name
      description = Faker::Book.publisher
      subitem.name = name
      subitem.description = description

      transporter = facade.update subitem
      expect(transporter.status_green?).to be_truthy

      expect(subitem.name).to eq(name)
      expect(subitem.description).to eq(description)
    end

    it 'return message error update with same name' do
      other_subitem = create(:ma_subitem, item: item)
      name = other_subitem.name
      subitem.name = name

      transporter = facade.update subitem
      expect(transporter.status_green?).to be false
    end
  end

  context 'delete' do
    it 'decrease one item' do
      subitem = create(:ma_subitem, item: item)

      expect {
        facade.delete(subitem)
      }.to change(MA::Subitem, :count).by(-1)
    end

    it 'return error account with association' do

      subitem = create(:ma_subitem, item: item)
      account = create(:ma_account, ac: ac)
      create(:ma_transaction, ac: ac, ma_account: account, ma_subitem: subitem)

      expect {
        transport = facade.delete subitem
        expect(transport.status_green?).to be false
        expect(transport.messages.first).to eq('Esse subitem está associado a uma TRANSAÇÃO, por tanto não poderá ser apagado!')
      }.to change(MA::Subitem, :count).by(0)

    end
  end

  context 'select' do

    it 'return list of MA::Transaction' do
      amount = 10
      create_list(:ma_subitem, amount, item: item)

      transporter = facade.select MA::Subitem
      expect(transporter.items.count).to eq(amount)
      expect(transporter.items.sample).to be_a(MA::Subitem)
    end

    it 'return list of items' do
      amount = 10
      create_list(:ma_subitem, amount, item: item)
      item2 = create(:ma_item, ac: ac)
      amount2 = 7
      create_list(:ma_subitem, amount2, item:item2)

      transporter = facade.select MA::Subitem, filter: { item_id: item.id }
      expect(transporter.items.count).to eq(amount)
      transporter = facade.select MA::Subitem, filter: { item_id: item2.id }
      expect(transporter.items.count).to eq(amount2)
    end
  end

  private

  def facade
    Facade.new ac
  end

end
