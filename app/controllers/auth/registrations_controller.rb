# frozen_string_literal: true

class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    super do |user|
      account = Account.create!(name: user.email)
      AccountUser.create!(user: user, account: account)
    end
  end

  def render_create_error
    render json: { errors: @resource.errors.full_messages }, status: 422
  end
end
