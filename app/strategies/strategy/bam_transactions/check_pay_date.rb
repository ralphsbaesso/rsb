class Strategy::BAMTransactions::CheckPayDate < Strategy

  def process
    transaction = model
    transaction.pay_date = transaction.transaction_date unless transaction.pay_date
  end

  def self.my_description

  end
end