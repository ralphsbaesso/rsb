class Strategy::MAUploadToTransactions::CheckExits < Strategy

  def process
    ma_account = model.ma_account
    list = bucket[:list]

    list.each do |hash|
      transaction_date = hash[:transaction_date]
      description = hash[:description]
      price_cents = hash[:price_cents]

      match = ma_account.ma_transactions.where(
        transaction_date: transaction_date,
        price_cents: price_cents
      ).where('description LIKE ?', "%#{description}%").limit(1).to_a.first

      hash[:to_remove] = true if match
    end

    bucket[:list] = list.reject { |hash| hash[:to_remove] }
  end
end