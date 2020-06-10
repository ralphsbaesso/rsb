class Facade
  attr_reader :transporter

  def initialize(account_user)
    @account_user = account_user
    @transporter = Transporter.new(account_user)
  end

  def insert(model, args = {}, options = {})
    execute(:insert, model, args, options)
  end

  def select(model, args = {}, options = {})
    execute(:select, model, args, options)
  end

  def update(model, args = {}, options = {})
    execute(:update, model, args, options)
  end

  def delete(model, args = {}, options = {})
    execute(:delete, model, args, options)
  end

  def method_missing(method, *parameters)
    model = parameters[0]
    args = parameters[1] || {}
    options = parameters[2] || {}
    execute(method, model, args, options)
  end

  private

  def execute(_method, model, args = {}, options = {})
    @options = options
    class_name = check_model(model)
    transporter.model = model
    transporter.bucket = args

    add_step "{ Method: #{_method}, model: #{class_name}, args: #{args} }"
    strategies = class_name.send("rules_of_#{_method}").map { |strategy| strategy.new(transporter, @options[:memoization]) }
    add_step "Quantidade de estrategias #{strategies.count}"

    strategies.each do |strategy|
      add_step "Executando Strategy: #{strategy.class.name}."
      strategy.process

      break if transporter.status == :red
    end

  rescue Exception => e
    puts e.message
    pp e.backtrace
    transporter.add_error_message 'Um erro inesperado aconteceu, tente novamente. Se persistir, entre em contato com o Adminstrador.'

    Event.application(
      @account_user,
      message: "Erro na execução do FACADE [#{e.message}]",
      transporter: transporter.as_json,
      steps: steps,
      error: e.message,
      class_error: e.class.name,
      backtrace: e.backtrace.present? ? e.backtrace[0..100] : nil,
      event_type: :error
    )
    # ExceptionNotifier.notify_exception(e, transporter.as_json)
  ensure
    add_step 'Finalizando execução no Facade.'
    return transporter
  end

  def add_step(value)
    new_value = "[#{DateTime.now.strftime('%FT%T.%L%:z')}] #{value}"
    puts new_value if @options[:show_step]
    steps << new_value
  end

  def check_model(model)
    if model.is_a?(Symbol) or model.is_a? String
      model.to_s.camelize.constantize
    elsif model.is_a? Class
      model
    else
      model.class.name.constantize
    end
  end

  def steps
    @steps ||= []
  end

end