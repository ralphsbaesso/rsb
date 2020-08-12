class Strategy::MAUploadToTransactions::CheckExits < Strategy

  def process
    bam_account = model.bam_account
    list = bucket[:list]

    list.each do |hash|
      transaction_date = hash[:transaction_date]
      description = hash[:description]
      price_cents = hash[:price_cents]

      match = bam_account.bam_transactions.where(
        transaction_date: transaction_date,
        price_cents: price_cents
      ).where('description LIKE ?', "%#{description}%").limit(1).to_a.first

      hash[:to_remove] = true if match
    end

    bucket[:list] = list.reject { |hash| hash[:to_remove] }
  end
end