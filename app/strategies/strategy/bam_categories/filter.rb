class Strategy::BAMCategories::Filter < Strategy

  def process
    self.data = current_account_user.bam_categories
  end

  def self.my_description
    <<~S
      Filtro
    S
  end
end