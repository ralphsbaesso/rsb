class Strategy::BAMUploadToTransactions::CheckType < Strategy

  def process
    account = model.bam_account
    return unless account.type

    if account.type.to_sym == :credit_card && model.paid_at.nil?
      add_error 'A conta tipo "Crédito" deve informar a data de pagamento.'
      set_status :red
      return
    end

    paid_at = model.paid_at
    date =
      if paid_at.is_a? Date
        paid_at
      else
        begin
          paid_at.to_date
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