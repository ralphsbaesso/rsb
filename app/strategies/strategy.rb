class Strategy

  def initialize(transporter, memoization = nil)
    raise 'Deve inicializar com objeto do tipo "Transporter"' unless transporter.is_a? Transporter
    @transporter = transporter
    @memoization = memoization #|| Bkps::Memoization.new
  end

  def process
    raise 'Must implement this method'
  end

  def messages
    @transporter.messages
  end

  def model
    @transporter.model
  end

  def bucket
    @transporter.bucket
  end

  def current_user
    @transporter.current_user
  end

  def current_account
    @transporter.current_account
  end

  def current_role
    AccountUser.find_by(user: current_user, account: current_account).role
  end

  def current_companies
    current_user.all_companies(current_account.id)
  end

  def status
    @transporter.status
  end

  def set_status(s)
    @transporter.status = s
    s != :red
  end

  def add_message(msg)
    @transporter.add_message msg
  end

  def add_error_message(msg)
    @transporter.add_error_message(msg)
  end

  def memoization
    @memoization
  end

  def items
    @transporter.items
  end

  def items=(value)
    @transporter.items = value
  end

  def current_account_user
    @transporter.current_account_user
  end

  def self.my_description
    ''
  end

end