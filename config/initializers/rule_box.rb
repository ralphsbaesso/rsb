RuleBox::Facade.configure do |config|
  config.add_dependency :account_user do |value, errors|
    errors << 'Must be an "AccountUser"' unless value.is_a? AccountUser
  end

  config.default_error_message = 'Ocorreu um erro inesperável. Tente novamente, se persistir entre em contato com o administrador do sistema.'
  config.show_steps = false #Rails.env.test?

  config.resolver_exception do |exception, facade|
    account_user = facade.current_account_user
    Event.add message: exception.message,
              app: :application,
              account_user: account_user,
              type: :error,
              class_error: exception.class,
              backtrace: exception.backtrace,
              facade: facade

  end
end