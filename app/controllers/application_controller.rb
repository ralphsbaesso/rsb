class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :set_current_account_user

  def set_current_account_user
    if current_user
      au = current_user.account_users.first
      @current_ac = au
      @current_account_user = au
    end
  end

  def current_ac
    @current_ac
  end

  def current_account_user
    @current_account_user
  end

  def facade
    Facade.new(@current_account_user)
  end

end
