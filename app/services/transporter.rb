class Transporter
  attr_accessor :messages, :model, :bucket, :current_user,
                :current_account, :status, :items,
                :current_account_user

  def initialize(account_user)
    @current_account_user = account_user
    @current_account = account_user.account
    @current_user = account_user.user
    # if account.present? and account.is_a?(Account)
    #   @current_account = account
    # else
    #   raise 'Deve passar a conta'
    # end
    #
    # if user == :system
    #   @current_user = SystemUser.new
    # elsif user.present?
    #   @current_user = user
    # else
    #   raise 'Deve passar um usuário válido'
    # end

    @items = []
    @messages = []
    @status = :green
    @bucket = {}
  end

  def item
    @model
  end

  def add_message(msg)
    if msg.is_a? Array
      @messages += msg
    else
      @messages << msg
    end
  end

  def add_error_message(msg)
    @messages = [msg]
    @status = :red
  end

  def to_data(type = nil, **options)
    if type.nil?
      { data: model }
    elsif type == :items

      source = items.page(options[:page]).per(options[:per_page])

      {
        data: source,
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

  def as_json(options = {})
    if model.is_a?(Symbol) || model.is_a?(String)
      item = model.to_s
    else
      item = model.as_json
      item.delete(:id) if model && !model.try(:persisted?) # por causa do mongoid que retorna id para objetos não salvos
    end

    data = {}
    self.bucket.each do |key, value|
      data[key] =
        if value.respond_to?(:attributes)
          value.attributes
        elsif value.respond_to?(:to_h)
          value.to_h
        else
          value.to_s
        end
    rescue StandardError
      data[key] = "#{value.class.to_s}"
    end
    data[:item] = item
    data[:status] = self.status
    data[:messages] = self.messages if self.messages.present?
    data
  end

  def main_data
    clone = self.clone
    clone.bucket = {}
    clone
  end

  def to_yaml(options = {})
    begin
      self.model.reload if self.model.respond_to? :reload
      self.bucket.values.each do |value|
        value.reload if value.respond_to? :reload
      end
    rescue StandardError => e
      puts e.message
      puts e.backtrace
    end

    super
  end

  class SystemUser
    def id
      nil
    end

    def name
      'system'
    end

    def email
      'system@bkps.com.br'
    end
  end

end