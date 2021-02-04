# frozen_string_literal: true

class Strategy::Labels::CheckExits < Strategy
  def process
    label = model
    original_name = label.original_name
    id = current_account_user.id

    match = Label.where(account_user_id: id, app: label.app)
                 .where('original_name LIKE ?', "%#{original_name}%")
                 .limit(1).to_a.first
    if match
      add_error 'Marcador já existe'
      set_status :red
    end
  end
end
