# == Schema Information
#
# Table name: moment_photos
#
#  id              :bigint           not null, primary key
#  description     :string
#  metadata        :jsonb
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#
# Indexes
#
#  index_moment_photos_on_account_user_id  (account_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#

require 'rails_helper'

RSpec.describe Moment::Photo, type: :model do
  let!(:user) { create(:user) }
  let!(:account) { create(:account) }
  let!(:au) { create(:account_user, user: user, account: account) }
  let(:path) { Rails.root.join('spec', 'files', 'moment', 'corinthians.png') }
  let(:path2) { Rails.root.join('spec', 'files', 'moment', 'battletoads.png') }

  describe 'have attributes' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:description) }
  end

  after do
    events(:error)
  end

  describe 'business rules' do
    context 'insert' do
      it 'must attach a File' do
      photo = build(:moment_photo, account_user: au, current_archive: path)
      facade = Facade.new(account_user: au)

      expect do
        facade.insert photo
        expect(facade.status_green?).to be_truthy
      end.to change(Archive, :count).by(1)
      end
    end

    context 'update' do
      it 'modify attributes' do
        photo = build(:moment_photo, account_user: au, current_archive: path)
        Facade.new(account_user: au).insert(photo)

        new_name = Faker::Name.name
        new_description = Faker::Lorem.sentence
        photo.name = new_name
        photo.description = new_description
        facade = Facade.new(account_user: au)

        facade.update photo
        expect(facade.status_green?).to be_truthy
        expect(photo.name).to eq(new_name)
        expect(photo.description).to eq(new_description)
      end

    end

    context 'delete' do
      it 'decrease one Moment::Photo' do
        photo = build(:moment_photo, account_user: au, current_archive: path)
        Facade.new(account_user: au).insert(photo)

        expect do
          expect do
            facade = Facade.new(account_user: au)
            facade.delete(photo)
          end.to change(Moment::Photo, :count).by(-1)
        end.to change(Archive, :count).by(-1)
      end

    end

    context 'select' do
      it 'all' do
        photo = build(:moment_photo, account_user: au, current_archive: path)
        Facade.new(account_user: au).insert(photo)
        photo2 = build(:moment_photo, account_user: au, current_archive: path2)
        Facade.new(account_user: au).insert(photo2)

        facade = Facade.new(account_user: au)
        facade.select Moment::Photo
        expect(facade.data.count).to eq(2)
      end

      it 'with label' do
        photo = build(:moment_photo, account_user: au, current_archive: path)
        Facade.new(account_user: au).insert(photo)

        [2, 5, 6].sample.times do
          create_clone(photo)
        end

        photo = Moment::Photo.all.sample
        label = build(:label, au: au)
        photo.labels << label
        photo.save

        facade = Facade.new(account_user: au)
        facade.select Moment::Photo, filter: { label_id: label.id }
        expect(facade.data.count).to eq(1)
      end

      it 'by generic' do
        photo = build(:moment_photo, account_user: au, current_archive: path)
        Facade.new(account_user: au).insert(photo)

        name = 'Timão subiu no ônibus em Marrocos'
        name1 = 'Vai timão'
        name2 = 'Então é NATAL.'
        [name, name1, name2].each do |new_name|
          create_clone(photo, name: new_name)
        end

        facade = Facade.new(account_user: au)
        facade.select Moment::Photo, filter: { generic: 'natal' }
        expect(facade.data.count).to eq(1)

        facade = Facade.new(account_user: au)
        facade.select Moment::Photo, filter: { generic: 'TIMÃO' }
        expect(facade.data.count).to eq(2)
      end
    end
  end

  private

  def create_clone(moment_photo, **attributes)
    new_attributes = moment_photo.attributes
    new_attributes.delete('id')
    attributes.each { |key, value| new_attributes[key.to_s] = value }

    clone = Moment::Photo.new(new_attributes)
    clone.save
    clone
  end

end
