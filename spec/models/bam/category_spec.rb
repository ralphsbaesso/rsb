# frozen_string_literal: true

# == Schema Information
#
# Table name: bam_categories
#
#  id              :bigint           not null, primary key
#  description     :string
#  level           :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_bam_categories_on_account_user_id           (account_user_id)
#  index_bam_categories_on_account_user_id_and_name  (account_user_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

require 'rails_helper'

RSpec.describe BAM::Category, type: :model do
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
        category = build(:bam_category, au: au, name: Faker::Name.name)

        facade = Facade.new(account_user: au)
        facade.insert category
        expect(facade.status).to eq(:green)
        expect(BAM::Category.count).to eq(1)
        expect(Event.count).to eq(0)
      end

      it "don't must save already exits name", :events do
        name = Faker::Name.name
        create(:bam_category, au: au, name: name)
        category = build(:bam_category, au: au, name: name)

        expect do
          facade = Facade.new(account_user: au)
          facade.insert category
          expect(facade.status).to eq(:red)
          expect(facade.errors.count).to eq(1)
        end.to change(BAM::Category, :count).by(0)

        expect(Event.count).to eq(0)
      end
    end

    context 'update' do
      it 'must update' do
        category = create(:bam_category, au: au, name: Faker::Name.name)
        name = Faker::Name.name
        category.name = name
        facade = Facade.new(account_user: au)
        facade.update category
        expect(facade.status).to eq(:green)
        expect(category.name).to eq(name)
      end
    end

    context 'delete' do
      it 'decrease one category' do
        category = create(:bam_category, au: au)
        expect do
          Facade.new(account_user: au).delete(category)
        end.to change(BAM::Category, :count).by(-1)

        expect(Event.count).to eq(0)
      end

      it 'return error account with association' do
        category = create(:bam_category, au: au)

        bam_account = create(:bam_account, au: au)
        create(:bam_transaction, au: au, bam_category: category, bam_account: bam_account)
        expect do
          facade = Facade.new(account_user: au)
          facade.delete(category)
          expect(facade.status).to eq(:red)
        end.to change(BAM::Category, :count).by(0)

        expect(Event.count).to eq(0)
      end
    end

    context 'select' do
      it 'return list of Category' do
        amount = 10
        create_list(:bam_category, amount, au: au)
        facade = Facade.new(account_user: au)
        facade.select BAM::Category.to_s
        expect(facade.data.count).to eq(amount)
      end
    end
  end
end
