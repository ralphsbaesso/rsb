# frozen_string_literal: true

class Strategy::Shares::DestroyModel < Strategy
  def process
    if status == :green
      model.destroy

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
    Exclui o Model
  S
end
