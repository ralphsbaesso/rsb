
class BAM::UploadToTransaction
  include RuleBox::Mapper

  attr_reader :bam_account, :file
  attr_accessor :pay_date

  def initialize(bam_account:, file:, pay_date: nil)
    raise 'Must pass "BAM"' unless bam_account.is_a?(BAM::Account)

    if file.is_a?(File) || File.file?(file)
      @file = File.open(file, 'r')
    else
      raise 'Must pass "File"'
    end

    @pay_date = pay_date
    @bam_account = bam_account
  end

  rules_of_insert Strategy::BAMUploadToTransactions::CheckSetting,
                  Strategy::BAMUploadToTransactions::CheckType,
                  Strategy::BAMUploadToTransactions::Parse,
                  Strategy::BAMUploadToTransactions::CheckExits,
                  Strategy::BAMUploadToTransactions::BuildTransactions

end
