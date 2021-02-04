# frozen_string_literal: true

class Strategy::Labels::CheckApp < Strategy
  def process
    apps = %w[bam book moment]
    label = model

    unless apps.include? label.app.to_s
      add_error 'Precisa associar o Marcador num aplicativo válido.'
      set_status :red
    end
  end
end
