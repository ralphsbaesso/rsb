# == Schema Information
#
# Table name: labels
#
#  id               :bigint           not null, primary key
#  app              :string
#  background_color :string
#  color            :string
#  name             :string
#  original_name    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_user_id  :bigint
#
# Indexes
#
#  index_labels_on_account_user_id                   (account_user_id)
#  index_labels_on_account_user_id_and_app_and_name  (account_user_id,app,name)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

require 'rails_helper'

RSpec.describe Label, type: :model do
  let!(:user) { create(:user) }
  let!(:account) { create(:account) }
  let!(:au) { create(:account_user, user: user, account: account) }
  let(:bam_account) { create(:bam_account, account_user: au) }

  after do
    events(:error)
  end

  describe 'business rules' do
    context 'insert' do
      it 'must save' do
        label = build(:label, au: au, app: :bam)

        facade = Facade.new(account_user: au)
        facade.insert label
        expect(facade.status).to eq(:green)
        expect(Label.count).to eq(1)
        expect(Event.count).to eq(0)
      end

      it "don't must save already exits name", :events do
        name = 'Aeiou'
        app = :bam
        first_label = build(:label, au: au, app: app, name: name)
        facade = Facade.new(account_user: au)
        facade.insert first_label

        label = build(:label, au: au, app: app, name: name)
        expect do
          facade = Facade.new(account_user: au)
          facade.insert label
          expect(facade.status).to eq(:red)
          expect(facade.errors.count).to eq(1)
        end.to change(Label, :count).by(0)

        expect(Event.count).to eq(0)
      end
    end

    context 'set_resources' do

      it 'one resource for one label' do
        label = create(:label, au: au, app: :bam)
        labels = [{ id: label.id, selected: true }]
        bam_transaction = create(:bam_transaction, account_user: au, bam_account: bam_account)
        resources = [{ id: bam_transaction.id, klass: bam_transaction.class.name }]

        facade = Facade.new(account_user: au)
        facade.set_resources :label,
                             app: :bam,
                             labels: labels,
                             resources: resources

        expect(facade.status_green?).to be_truthy
        expect(bam_transaction.associated_labels.count).to eq(1)

        # duplicated, don't increase
        labels = [{ id: label.id, selected: true }]
        facade = Facade.new(account_user: au)
        facade.set_resources :label,
                             app: :bam,
                             labels: labels,
                             resources: resources

        expect(facade.status_green?).to be_truthy
        expect(bam_transaction.associated_labels.count).to eq(1)

        # deselected
        labels = [{ id: label.id, selected: false }]
        facade = Facade.new(account_user: au)
        facade.set_resources :label,
                             app: :bam,
                             labels: labels,
                             resources: resources

        expect(facade.status_green?).to be_truthy
        expect(bam_transaction.associated_labels.count).to eq(0)
      end

      it 'two resource for three label' do
        label = create(:label, au: au, app: :bam)
        label1 = create(:label, au: au, app: :bam)
        label2 = create(:label, au: au, app: :bam)

        bam_transaction = create(:bam_transaction, au: au, bam_account: bam_account)
        bam_transaction1 = create(:bam_transaction, au: au, bam_account: bam_account)
        klass = BAM::Transaction.to_s

        labels = [label, label1, label2].map { |l| { id: l.id, selected: true}}
        resources = [{ id: bam_transaction.id, klass: klass }, { id: bam_transaction1.id, klass: klass }]

        facade = Facade.new(account_user: au)
        facade.set_resources :label,
                             app: :bam,
                             labels: labels,
                             resources: resources

        expect(facade.status_green?).to be_truthy
        expect(bam_transaction.associated_labels.count).to eq(3)
        expect(bam_transaction1.associated_labels.count).to eq(3)

        # deselected
        labels = [{ id: label.id, selected: false }]
        facade = Facade.new(account_user: au)
        facade.set_resources :label,
                             app: :bam,
                             labels: labels,
                             resources: resources

        expect(facade.status_green?).to be_truthy
        expect(bam_transaction.associated_labels.count).to eq(2)

        expect(Label.count).to eq(3)
      end

    end
  end
end
