class Strategy::MAAccounts::Filter < Strategy

  def process
    self.items = current_account_user.ma_accounts
  end

  def self.my_description
    <<~S
      Filtro
    S
  end
end