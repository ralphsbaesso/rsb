# frozen_string_literal: true

class BAM::UploadToTransaction
  include RuleBox::Mapper

  attr_reader :bam_account, :file
  attr_accessor :paid_at

  def initialize(bam_account:, file:, paid_at: nil)
    @file = file
    @paid_at = paid_at
    @bam_account = bam_account
  end

  rules_of_insert Strategy::BAMUploadToTransactions::CheckAttributes,
                  Strategy::BAMUploadToTransactions::CheckSetting,
                  Strategy::BAMUploadToTransactions::CheckType,
                  Strategy::BAMUploadToTransactions::Parse,
                  Strategy::BAMUploadToTransactions::CheckExits,
                  Strategy::BAMUploadToTransactions::BuildTransactions
end
