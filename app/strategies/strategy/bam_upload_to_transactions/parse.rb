# frozen_string_literal: true

class Strategy::BAMUploadToTransactions::Parse < Strategy
  def process
    account = model.bam_account
    file = model.file
    fields = account.fields

    list = []
    File.readlines(file).each do |line|
      cells =
        begin
          line.split ';'
        rescue StandardError
          line.encode('UTF-8', 'Windows-1252').split ';'
        end

      hash = {}
      fields.each_with_index do |field, index|
        field = field.to_sym
        value = cells[index].strip

        if field == :transacted_at
          hash[field] = Util::Parser.to_datetime value
        elsif field == :paid_at
          hash[field] = Util::Parser.to_datetime value
        elsif field == :description
          hash[field] = "[#{value}]"
        elsif field == :annotation
          hash[field] = "<p>#{value}</p>"
        elsif field == :value
          hash[:price_cents] = Util::Parser.to_cents(value)
        elsif field == :reverse_value
          hash[:price_cents] = Util::Parser.to_cents(value) { |v| v * -1 }
        elsif field == :symbol
          new_value = value.delete(' "\'')
          hash[field] =
            if new_value == 'C'
              :positive
            elsif new_value == 'D'
              :negative
            end
        else
          next
        end

      rescue StandardError
        next
      end

      hash[:paid_at] = model.paid_at if account.type&.to_sym == :credit_card
      list << hash if hash.present?
    end

    list.each do |hash|
      hash[:price_cents] *= -1 if hash[:symbol] == :negative &&
                                  hash[:price_cents].is_a?(Integer)
    end

    bucket[:list] = list
  end
end
