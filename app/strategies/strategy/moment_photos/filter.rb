class Strategy::MomentPhotos::Filter < Strategy

  desc 'Filtro para Moment::Photos'
  def process
    filter = bucket[:filter] || {}
    query = current_account_user.moment_photos

    # by label
    query = query.joins(:labels).where(labels: { id: filter[:label_id] }) if filter[:label_id].present?
    # by generic
    query = query.where('name ILIKE ?', "%#{filter[:generic]}%") if filter[:generic].present?

    self.data = query
  end

end