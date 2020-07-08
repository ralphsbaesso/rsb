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

      transporter = Facade.new(account_user).insert transaction
      messages += transporter.messages unless transporter.status_green?
    end

    if messages.present?
      add_message messages
      set_status :yellow
    end
  end
end