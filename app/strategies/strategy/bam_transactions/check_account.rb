# frozen_string_literal: true

class Strategy::BAMTransactions::CheckAccount < Strategy
  def process
    return if model.bam_account_id

    add_error 'Deve associar a transação ao uma Conta.'
    set_status :yellow
  end
end
