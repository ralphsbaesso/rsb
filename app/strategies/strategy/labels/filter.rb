# frozen_string_literal: true

class Strategy::Labels::Filter < Strategy
  desc 'Filtro para Label'
  def process
    filter = bucket[:filter] || {}
    query = current_account_user.labels
    query = query.where(app: filter[:app]) if filter[:app].present?

    self.data = query
  end
end
