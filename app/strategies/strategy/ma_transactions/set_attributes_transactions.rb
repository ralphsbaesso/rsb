class Strategy::MATransactions::SetAttributesTransactions < Strategy

  def process

    transfer = entity

    origin_transaction = transfer.origin_transaction
    destiny_transaction = transfer.destiny_transaction

    if bucket[:attributes_orgin].present?
      bucket[:attributes_orgin].each do |key, value|
        origin_transaction[key] = value if origin_transaction.has_attribute? key
        origin_transaction.price = value if key == 'price'
      end
    end

    if destiny_transaction and bucket[:attributes_destiny].present?
      bucket[:attributes_destiny].each do |key, value|
        destiny_transaction[key] = value if destiny_transaction.has_attribute? key
        destiny_transaction.price = value if key == 'price'
      end
    elsif bucket[:attributes_destiny].present? # nao ha destiny
      transfer.destiny_transaction = Transaction.new(bucket[:attributes_destiny])
    else
      bucket[:delete_destiny] = destiny_transaction.id if destiny_transaction
      transfer.destiny_transaction = nil
    end

    true
  end
end