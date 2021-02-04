# frozen_string_literal: true

module Util
  class Parser
    class << self
      def to_cents(value)
        new_value =
          if value.is_a? Float
            (value * 100).to_i
          elsif value.is_a? String
            value.gsub(/[A-Z]|[a-z]/, '').delete('$,. "\'').to_i
          end

        block_given? ? yield(new_value) : new_value
      end

      def to_datetime(date, format = nil)
        new_date =
          if date.is_a? DateTime
            date
          elsif format.present?
            DateTime.strptime(date, format)
          elsif date.is_a?(Date) || date.is_a?(Time)
            date.to_datetime
          elsif date.is_a?(String) && date.length == 8 && date.match(/^\d+$/)
            DateTime.strptime(date, '%Y%m%d')
          elsif date.is_a?(String) && date.length == 8
            DateTime.strptime(date, '%d%m%Y')
          elsif date.is_a?(String) && date.length == 7 && date.include?('/')
            DateTime.strptime(date, '%m/%Y')
          elsif date.is_a?(String) && date.match(%r{^([0-2][0-9]|(3)[0-1])(/)(((0)[0-9])|((1)[0-2]))(/)\d{4}$})
            DateTime.strptime(date, '%d/%m/%Y')
          else
            date.to_datetime
          end

        new_date.change offset: '-03:00'
      rescue StandardError
        nil
      end
    end
  end
end
