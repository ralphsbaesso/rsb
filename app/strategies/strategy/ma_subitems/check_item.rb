class Strategy::MASubitems::CheckItem < Strategy

  def process
    return if model.item

    add_message 'Deve associar a um Item.'
    set_status :red
  end

  def self.my_description
    <<~S
      Verifica se já está utilizando nome do MA::Subitem no MA::Item
    S
  end
end