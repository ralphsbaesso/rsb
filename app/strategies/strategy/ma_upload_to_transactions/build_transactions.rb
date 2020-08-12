class Strategy::MAUploadToTransactions::BuildTransactions < Strategy

  def process
    bam_account = model.bam_account
    account_user = bam_account.account_user
    list = bucket[:list]

    messages = []
    list.each do |hash|
      transaction = BAM::Transaction.new(
        bam_account: bam_account,
        account_user: account_user,
        transaction_date: hash[:transaction_date],
        price_cents: hash[:price_cents],
        description: hash[:description],
        pay_date: hash[:pay_date]
      )

      facade = Facade.new(account_user: account_user)
      facade.insert transaction
      messages += facade.errors unless facade.status_green?
    end

    if messages.present?
      add_error messages
      set_status :yellow
    end
  end
end