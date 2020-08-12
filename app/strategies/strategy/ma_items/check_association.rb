class Strategy::MAItems::CheckAssociation < Strategy

  def process
    item = model

    if item.bam_transactions.limit(1).to_a.present?
      add_error 'Não pode apagar esse item, existe transações associado a ele.'
      set_status :red
    end
  end

  def self.my_description
    <<~S
      Verifica há BAM::Subitems associado no item
    S
  end
end