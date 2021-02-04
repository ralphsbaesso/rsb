# frozen_string_literal: true

namespace :util do
  desc 'Create user to environment develop'
  task create_user: :environment do
    # unless Rails.env.production?
    #   AccountUser.destroy_all
    #   User.destroy_all
    #   Account.destroy_all
    # end

    user = User.create(email: 'user@user.com', password: '123456')
    if user.errors.present?
      pp user.errors.full_messages
      return
    end
    account = Account.create(name: 'Account 0')
    if account.errors.present?
      pp account.errors.full_messages
      return
    end

    au = AccountUser.create(user: user, account: account)
    if au.errors.present?
      pp au.errors.full_messages
      return
    end
    puts :created
  end
end
