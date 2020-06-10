# frozen_string_literal: true

module EventHelper

  def events(type = nil)
    events = type.present? ? Event.where(event_type: type) : Event.all

    count = events.count
    puts "\t### Events ###" unless count.zero?

    events.each_with_index do |event, index|
      puts "\tEvent: #{index + 1}/#{count}."
      puts ''
      pp event
      puts ''
      puts "\t>>>>>>>>>>>>>>>"
      puts ''
    end

    puts "\t### Total #{count} ###" unless count.zero?
  end
end