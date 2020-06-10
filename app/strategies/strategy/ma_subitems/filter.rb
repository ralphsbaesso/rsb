class Strategy::MASubitems::Filter < Strategy

  def process
    filter = bucket[:filter] || {}
    query = current_account_user.ma_subitems
    query = query.where(item_id: filter[:item_id]) if filter[:item_id].present?

    self.items = query
  end

  def self.my_description
    <<~S
      Filtro para MA::Subitems
    S
  end
end