# frozen_string_literal: true

class Strategy::Events::Filter < Strategy
  desc 'Filtro para Event'
  def process
    self.data = Event.all
  end
end
