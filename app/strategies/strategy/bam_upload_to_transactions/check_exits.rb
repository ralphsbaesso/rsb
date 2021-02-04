# frozen_string_literal: true

class Strategy::BAMUploadToTransactions::CheckExits < Strategy
  def process
    bam_account = model.bam_account
    list = bucket[:list]

    list.each do |hash|
      transacted_at = hash[:transacted_at]
      description = hash[:description]
      price_cents = hash[:price_cents]

      match = bam_account.bam_transactions.where(
        transacted_at: transacted_at,
        price_cents: price_cents
      ).where('description LIKE ?', "%#{description}%").limit(1).to_a.first

      hash[:to_remove] = true if match
    end

    bucket[:list] = list.reject { |hash| hash[:to_remove] }
  end
end
