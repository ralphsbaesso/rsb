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

  end
end
