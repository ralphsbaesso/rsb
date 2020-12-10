class Strategy::BAMTransactions::CheckTransactionDate < Strategy

  def process
    transaction = model
    date = transaction.transacted_at

    transaction.transacted_at =
      begin
        if date.is_a?(DateTime)
          date
        elsif date.respond_to? :to_date
          date.to_date
        end
      rescue StandardError
        nil
      end

    unless transaction.transacted_at
      add_error 'Data da transação inválida.'
      set_status :yellow
    end

  end

  def self.my_description

  end
end