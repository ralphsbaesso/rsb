class Strategy::Labels::CheckLabels < Strategy

  desc 'Verifica se os Labels passado por parametro são válidos'
  def process
    app = bucket[:app]

    labels = []
    bucket[:labels].each do |hash|
      id = hash[:id]
      label = current_account_user.labels.find_by(app: app, id: id)
      add_error "Não foi encontrado o Label com os attributos: { id: #{id}, app: #{app}}." unless label

      label.selected = hash[:selected]
      labels << label
    end

    bucket[:labels] = labels
    set_status :red if errors.present?
  end
end
