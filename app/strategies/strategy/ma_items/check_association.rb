class Strategy::MAItems::CheckAssociation < Strategy

  def process
    item = model

    if item.ma_transactions.limit(1).to_a.present?
      add_message 'Não pode apagar esse item, existe transações associado a ele.'
      set_status :red
    end
  end

  def self.my_description
    <<~S
      Verifica há MA::Subitems associado no item
    S
  end
end