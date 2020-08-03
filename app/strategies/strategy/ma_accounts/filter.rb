class Strategy::MAAccounts::Filter < Strategy

  desc 'Filtro para "ManagerAccount"'
  def process
    self.data = current_account_user.ma_accounts
  end

end