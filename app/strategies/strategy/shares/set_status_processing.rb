class Strategy::Shares::SetStatusProcessing < Strategy

  def process
    model.status = :processing
  end

  def self.my_description
    <<~S
      Atribui o "status" para "processing".
    S
  end
end