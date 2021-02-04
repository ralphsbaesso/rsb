# frozen_string_literal: true

class Strategy::MomentPhotos::Filter < Strategy
  desc 'Filtro para Moment::Photos'
  def process
    filter = bucket[:filter] || {}
    query = current_account_user.moment_photos

    # by label
    query = query.joins(:labels).where(labels: { id: filter[:label_id] }) if filter[:label_id].present?
    # by generic
    query = query.joins(:archive).where('archives.filename ILIKE ?', "%#{filter[:generic]}%") if filter[:generic].present?
    # by data
    type_date = filter[:type_date] == 'created_at' ? filter[:type_date] : :updated_at
    start_date = filter[:start_date]
    end_date = filter[:end_date]
    if start_date && end_date
      query = query.where(type_date => (start_date..end_date))
    elsif start_date
      query = query.where("#{type_date} > ?", start_date)
    elsif end_date
      query = query.where("#{type_date} < ?", end_date)
    end

    self.data = query
  end
end
