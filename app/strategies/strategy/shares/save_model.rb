# frozen_string_literal: true

class Strategy::Shares::SaveModel < Strategy
  def process
    if status == :green
      model.save

      if model.errors.present?
        model.errors.full_messages.each do |error|
          add_error error
        end
        set_status :red
      end
    else
      set_status :red
    end
  end

  desc <<~S
    Verifica o status do model
    Se status igual a :green e model sem erros, salva o model
    Se não muda seu status para :red
  S
end
