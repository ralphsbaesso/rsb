# frozen_string_literal: true

class Strategy::Shares::OrderBy < Strategy
  def process
    order = bucket.dig(:filter, :order)&.with_indifferent_access || {}

    klass =
      if model.is_a? Class
        model
      elsif model.is_a?(Symbol) || model.is_a?(String)
        model.to_s.camelize.constantize
      else
        model.class.name.constantize
      end

    sort = {}
    klass.column_names.each do |column|
      sort[column] = order[column] if order[column.to_sym] && %w[asc desc].include?(order[column].to_s)
    end

    sort[:updated_at] = 'desc' unless sort.present?
    self.data = data.order(sort)
  end

  desc <<~S
    Ordena pelo parametros passado na chave bucket[filter][order]
  S
end
