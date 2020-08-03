class Strategy::MAUploadToTransactions::CheckType < Strategy

  def process
    account = model.ma_account
    return unless account.type

    if account.type.to_sym == :credit_card && model.pay_date.nil?
      add_error 'A conta tipo "Crédito" deve informar a data de pagamento.'
      set_status :red
      return
    end

    pay_date = model.pay_date
    date =
      if pay_date.is_a? Date
        pay_date
      else
        begin
          pay_date.to_date
        rescue StandardError
          nil
        end
      end

    unless date
      add_error 'Data de pagamento inválida.'
      set_status :red
    end
  end
end