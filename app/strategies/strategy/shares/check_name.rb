class Strategy::Shares::CheckName < Strategy

  desc 'Verifica se já está utilizando este nome'
  def process
    klazz = model.class.name.constantize

    model_from_db = klazz.where(
      account_user: current_account_user
    ).where(
      'LOWER(name) = ? AND id <> ?', model.name.downcase, model.id || 0
    ).first

    if model_from_db
      add_error 'Nome já em uso.'
      set_status :red
    end

  end

end