class Strategy::MASubitems::CheckAssociation < Strategy

  def process
    subitem = model

    if current_account_user.ma_transactions.where(ma_subitem: subitem).first
      add_message 'Esse subitem está associado a uma TRANSAÇÃO, por tanto não poderá ser apagado!'
      set_status :red
    end

  end

  def self.my_description
    <<~S
      Verifica há MA::Subitems associado no item
    S
  end
end