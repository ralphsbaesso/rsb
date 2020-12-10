
class BAM::UploadToTransaction
  include RuleBox::Mapper

  attr_reader :bam_account, :file
  attr_accessor :paid_at

  def initialize(bam_account:, file:, paid_at: nil)
    raise 'Must pass "BAM"' unless bam_account.is_a?(BAM::Account)

    if file.is_a?(File) || File.file?(file)
      @file = File.open(file, 'r')
    else
      raise 'Must pass "File"'
    end

    @paid_at = paid_at
    @bam_account = bam_account
  end

  rules_of_insert Strategy::BAMUploadToTransactions::CheckSetting,
                  Strategy::BAMUploadToTransactions::CheckType,
                  Strategy::BAMUploadToTransactions::Parse,
                  Strategy::BAMUploadToTransactions::CheckExits,
                  Strategy::BAMUploadToTransactions::BuildTransactions

end
