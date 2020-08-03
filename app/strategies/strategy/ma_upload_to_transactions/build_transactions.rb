class Strategy::MAUploadToTransactions::BuildTransactions < Strategy

  def process
    ma_account = model.ma_account
    account_user = ma_account.account_user
    list = bucket[:list]

    messages = []
    list.each do |hash|
      transaction = MA::Transaction.new(
        ma_account: ma_account,
        account_user: account_user,
        transaction_date: hash[:transaction_date],
        price_cents: hash[:price_cents],
        description: hash[:description],
        pay_date: hash[:pay_date]
      )

      facade = Facade.new(account_user: account_user)
      facade.insert transaction
      messages += facade.errors unless facade.status_green?
    end

    if messages.present?
      add_error messages
      set_status :yellow
    end
  end
end