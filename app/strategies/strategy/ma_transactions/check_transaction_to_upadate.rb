module Strategy
  module MATransactions
    class CheckTransactionToUpdate < Strategy

      def self.process(transporter)

        transfer = transporter.entity

        if transfer.is_a? Transfer

          transaction = Transaction.new(transporter.bucket[:transaction_params])

          messages = []
          if transaction
            t = Transporter.new
            t.entity = transaction
            Strategy::StrategyTransaction::RequiredFields.process(t)
            messages += t.messages
          end

          if messages.present?
            transporter.add_message messages
            transporter.status = 'RED'
            return false
          end

        end

        true
      end
    end
  end
end