# frozen_string_literal: true

class Strategy::Labels::CheckResources < Strategy
  desc 'Verifica os recursos passados por parâmetro se são válidos.'
  def process
    resources = []

    bucket[:resources].each do |hash|
      klass = hash[:klass]
      id = hash[:id]
      resources << klass.camelize.constantize.find(id)
    end

    bucket[:resources] = resources
  end
end
