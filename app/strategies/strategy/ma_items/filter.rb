class Strategy::MAItems::Filter < Strategy

  def process
    self.items = current_account_user.ma_items
  end

  def self.my_description
    <<~S
      Filtro
    S
  end
end