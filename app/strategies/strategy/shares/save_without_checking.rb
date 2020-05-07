class Strategy::Shares::SaveWithoutChecking < Strategy

  def process
    model.save!
  end

  def self.my_description
    <<~S
      Salva o model sem checar o status do processo
      Obs: o model deve estar sem erros, se não irá gerar uma exceção!
    S
  end
end