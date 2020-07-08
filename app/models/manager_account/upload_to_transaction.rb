
class ManagerAccount::UploadToTransaction
  attr_reader :ma_account, :file
  attr_accessor :pay_date

  def initialize(ma_account:, file:, pay_date: nil)
    raise 'Must pass "ManagerAccount"' unless ma_account.is_a?(ManagerAccount::Account)

    if file.is_a?(File) || File.file?(file)
      @file = File.open(file, 'r')
    else
      raise 'Must pass "File"'
    end

    @pay_date = pay_date
    @ma_account = ma_account
  end

  def self.rules_of_insert
    [
      Strategy::MAUploadToTransactions::CheckSetting,
      Strategy::MAUploadToTransactions::CheckType,
      Strategy::MAUploadToTransactions::Parse,
      Strategy::MAUploadToTransactions::CheckExits,
      Strategy::MAUploadToTransactions::BuildTransactions
    ]
  end

end
