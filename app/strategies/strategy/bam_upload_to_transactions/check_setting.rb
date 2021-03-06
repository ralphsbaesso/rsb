# frozen_string_literal: true

class Strategy::BAMUploadToTransactions::CheckSetting < Strategy
  def process
    account = model.bam_account
    fields = account.fields

    unless fields.present?
      add_error 'A conta não está configurada para fazer upload de arquivos.'
      set_status :red
    end
  end
end
