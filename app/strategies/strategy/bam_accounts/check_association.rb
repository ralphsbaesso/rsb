# frozen_string_literal: true

class Strategy::BAMAccounts::CheckAssociation < Strategy
  def process
    account = model

    if account.bam_transactions.count.positive?
      add_error 'Existe TRASAÇÕES associada a essa conta!'
      set_status :red
    end
  end

  def self.my_description
    <<~S
      Verifica há BAM::Transaction associado a BAM::Account
    S
  end
end
