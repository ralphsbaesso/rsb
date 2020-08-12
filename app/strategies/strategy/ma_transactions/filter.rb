class Strategy::MATransactions::Filter < Strategy

  def process
    filter = bucket[:filter] || {}
    query = current_account_user.bam_transactions
    query = query.joins(:labels).where(labels: { id: filter[:label_id] }) if filter[:label_id]

    self.data = query
  end

  def self.my_description
    <<~S
      Filtro para BAM::Transacion
    S
  end
end