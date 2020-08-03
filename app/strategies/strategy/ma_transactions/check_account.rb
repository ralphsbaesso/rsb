class Strategy::MATransactions::CheckAccount < Strategy

  def process
    return if model.ma_account_id

    add_error 'Deve associar a transação ao uma Conta.'
    set_status :yellow
  end
end