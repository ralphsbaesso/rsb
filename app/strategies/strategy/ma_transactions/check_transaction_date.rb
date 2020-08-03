class Strategy::MATransactions::CheckTransactionDate < Strategy

  def process
    transaction = model
    date = transaction.transaction_date

    transaction.transaction_date =
      begin
        if date.is_a?(DateTime)
          date
        elsif date.respond_to? :to_date
          date.to_date
        end
      rescue StandardError
        nil
      end

    unless transaction.transaction_date
      add_error 'Data da transação inválida.'
      set_status :yellow
    end

  end

  def self.my_description

  end
end