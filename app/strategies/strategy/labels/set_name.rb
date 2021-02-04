# frozen_string_literal: true

class Strategy::Labels::SetName < Strategy
  def process
    label = model
    label.original_name = label.name.downcase.strip
  end
end
