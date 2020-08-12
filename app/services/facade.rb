class Facade < RuleBox::Facade

  def status_green?
    @status == :green
  end

  def to_data(type = nil, json_options: {}, **options)
    if type.nil?
      { data: model }
    elsif type == :data
      source = data.page(options[:page]).per(options[:per_page])

      {
        data: source.as_json(json_options),
        meta: {
          total_count: source.total_count,
          count: source.count,
          total_pages: source.total_pages,
          current_page: source.current_page,
          prev_page: source.prev_page,
          next_page: source.next_page,
        }
      }
    end
  end
end