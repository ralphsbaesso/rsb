class Strategy::BAMTransactions::Filter < Strategy

  def process
    filter = bucket[:filter] || {}
    query = current_account_user.bam_transactions

    # by label
    query = query.joins(:labels).where(labels: { id: filter[:label_id] }) if filter[:label_id].present?
    # by generic
    query = query.where('description ILIKE ?', "%#{filter[:generic]}%") if filter[:generic].present?
    # by category
    query = query.where(bam_category_id: filter[:bam_category_id]) if filter[:bam_category_id].present?
    # by item
    query = query.where(bam_item_id: filter[:bam_item_id]) if filter[:bam_item_id].present?
    # by account
    query = query.where(bam_account_id: filter[:bam_account_id]) if filter[:bam_account_id].present?

    # by data
    type_date = %w[created_at transaction_date pay_date].include?(filter[:type_date]) ? filter[:type_date] : :updated_at
    start_date = filter[:start_date]
    end_date = filter[:end_date]
    if start_date && end_date
      query = query.where(type_date => (start_date..end_date))
    elsif start_date
      query = query.where('? > ?', type_date, start_date)
    elsif end_date
      query = query.where('? < ?', type_date, end_date)
    end

    self.data = query
  end

  def self.my_description
    <<~S
      Filtro para BAM::Transacion
    S
  end
end