class Strategy::BAMTransactions::CheckPayDate < Strategy

  def process
    transaction = model
    transaction.paid_at = transaction.transacted_at unless transaction.paid_at
  end

  def self.my_description

  end
end