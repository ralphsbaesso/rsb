# frozen_string_literal: true

namespace :util do
  desc 'Create user to environment develop'
  task create_user: :environment do
    unless Rails.env.production?
      User.destroy_all
      Account.destroy_all
      AccountUser.destroy_all
    end

    user = User.create(name: 'user@user.com', password: '123456')
    account = Account.create(name: 'Account 0')
    AccountUser.create(user: user, account: account)
  end

end
