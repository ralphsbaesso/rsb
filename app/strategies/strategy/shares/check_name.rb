class Strategy::Shares::CheckName < Strategy

  def process
    klazz = model.class.name.constantize

    model_from_db = klazz.where(
      account_user: current_account_user
    ).where(
      'LOWER(name) = ? AND id <> ?', model.name.downcase, model.id || 0
    ).first

    if model_from_db
      add_message 'Nome já em uso.'
      set_status :red
    end

  end

  def self.my_description
    <<~S
      Verifica se já está utilizando este nome
    S
  end
end