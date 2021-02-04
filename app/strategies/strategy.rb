# frozen_string_literal: true

class Strategy < RuleBox::Strategy
  def current_user
    @current_user ||= current_account_user&.user
  end

  def current_account
    @current_account ||= current_account_user&.account
  end
end
