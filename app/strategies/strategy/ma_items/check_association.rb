class Strategy::MAItems::CheckAssociation < Strategy

  def process
    item = model

    if item.ma_subitems.count.positive?
      add_message 'Esse item está associado a um SUBITEM, por tanto não poderá ser apagado!'
      set_status :red
    end

  end

  def self.my_description
    <<~S
      Verifica há MA::Subitems associado no item
    S
  end
end