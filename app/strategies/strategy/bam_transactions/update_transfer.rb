# frozen_string_literal: true

class Strategy::BAMTransactions::UpdateTransfer < Strategy
  def process
    transfer = entity

    if status == :green

      origin = transfer.origin_transaction
      destiny = transfer.destiny_transaction

      origin.save!

      destiny_id = bucket[:delete_destiny]
      if destiny_id.present?
        Transaction.destroy destiny_id
      else
        destiny&.save!
      end
    end

    transfer.save!

    true
  end
end
