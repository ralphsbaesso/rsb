# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::SessionsController, type: :request do

  context '#create' do
    it 'login' do
      password = 'Abc123'
      user = build(:user, password: password)
      email = user.email

      # create
      post '/auth', params: { email: email, password: password, password_confirmation: password }
      # login
      post '/auth/sign_in', params: { email: email, password: password }

      data = JSON.parse response.body
      user = data['data']
      expect(user['email']).to eq(email)
    end

  end

  context '#cycle' do

    it 'sign_in -> authenticator -> sign_out' do
      user = create(:user)
      login user

      get '/auth/validate_token', headers: @auth_tokens
      expect(response).to have_http_status :ok

      delete '/auth/sign_out', headers: @auth_tokens
      expect(response).to have_http_status :ok

      get '/auth/validate_token', headers: @auth_tokens
      expect(response).to have_http_status 401

      # repeat
      login user

      get '/auth/validate_token', headers: @auth_tokens
      expect(response).to have_http_status :ok

      delete '/auth/sign_out', headers: @auth_tokens
      expect(response).to have_http_status :ok

      get '/auth/validate_token', headers: @auth_tokens
      expect(response).to have_http_status 401
    end

  end
end
