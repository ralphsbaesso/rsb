class Strategy::Shares::DestroyModel < Strategy

  def process
    if status == :green
      model.destroy!
    end
  end

  def self.my_description
    <<~S
      Exclui o Model
    S
  end
end