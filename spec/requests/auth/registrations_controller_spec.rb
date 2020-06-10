# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::RegistrationsController, type: :request do

  context '#create' do
    it 'must create user' do

      email = Faker::Internet.email
      password = 'Abc123'
      password_confirmation = 'Abc123'
      post '/auth', params: { email: email, password: password, password_confirmation: password_confirmation }

      expect(User.count).to eq(1)
      data = JSON.parse response.body
      user = data['data']
      expect(user['email']).to eq(email)

      user = User.last
      expect(user.accounts.count).to eq(1)
      expect(user.account_users.count).to eq(1)
    end

  end
end
