class Strategy::Labels::CheckApp < Strategy

  def process
    apps = %w[manager_account book photo]
    label = model

    unless apps.include? label.app.to_s
      add_message 'Precisa associar o Marcador num aplicativo válido.'
      set_status :red
    end

  end
end