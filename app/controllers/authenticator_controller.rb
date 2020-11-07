class AuthenticatorController < ApplicationController
  # before_action :authenticate_user!

  private

  def not_authorized!(*args)
    options = args.extract_options!
    error = options[:message] || I18n.t('action_access.redirection_message', default: 'Not authorized.')
    render json: { data: { errors: [error] } }, status: :unprocessable_entity
  end
end