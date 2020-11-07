class Strategy::BAMAccounts::Filter < Strategy

  desc 'Filtro para "BAM"'
  def process
    self.data = current_account_user.bam_accounts
  end

end