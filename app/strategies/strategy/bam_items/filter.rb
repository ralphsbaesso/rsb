# frozen_string_literal: true

class Strategy::BAMItems::Filter < Strategy
  def process
    self.data = current_account_user.bam_items
  end

  def self.my_description
    <<~S
      Filtro
    S
  end
end
