# frozen_string_literal: true

class Strategy::Shares::SetStatusProcessed < Strategy
  def process
    model.status = :processed
  end

  def self.my_description
    <<~S
      Atribui o "status" para "processed".
    S
  end
end
