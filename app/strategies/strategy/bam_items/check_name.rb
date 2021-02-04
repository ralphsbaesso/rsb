# frozen_string_literal: true

class Strategy::BAMItems::CheckName < Strategy
  def process
    item = model

    if current_account_user.bam_items.where(name: item.name).first
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
