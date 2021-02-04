# frozen_string_literal: true

class Strategy::Shares::SelectSql < Strategy
  def process
    fields = bucket.dig(:filter, :fields) || bucket.dig(:filter, :select_fields)
    return unless fields.present?

    self.data = data.select(fields)
  end
end
