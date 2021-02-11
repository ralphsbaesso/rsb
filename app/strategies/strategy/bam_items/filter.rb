# frozen_string_literal: true

class Strategy::BAMItems::Filter < Strategy
  def process
    filter = bucket[:filter] || {}
    query = current_account_user.bam_items
    # generic
    query = query.where('name ILIKE :generic OR description ILIKE :generic', generic: "%#{filter[:generic]}%") if filter[:generic].present?

    self.data = query
  end

  def self.my_description
    <<~S
      Filtro
    S
  end
end
