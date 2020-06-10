class Strategy::MASubitems::CheckName < Strategy

  def process
    subitem = model
    item = subitem.item

    subitem_from_db = item.subitems.where(
      'LOWER(name) = ? AND id <> ?', model.name.downcase, model.id || 0
    ).first

    if subitem_from_db
      add_message 'Nome já em uso.'
      set_status :red
    end

  end

  def self.my_description
    <<~S
      Verifica se já está utilizando nome do MA::Subitem no MA::Item
    S
  end
end