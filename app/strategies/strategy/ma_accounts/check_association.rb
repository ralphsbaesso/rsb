class Strategy::MAAccounts::CheckAssociation < Strategy

  def process
    account = model

    if account.ma_transactions.count.positive?
      add_message 'Existe TRASAÇÕES associada a essa conta!'
      set_status :red
    end

  end

  def self.my_description
    <<~S
      Verifica há MA::Transaction associado a MA::Account
    S
  end
end