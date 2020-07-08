class Strategy::MAUploadToTransactions::CheckSetting < Strategy

  def process
    account = model.ma_account
    fields = account.fields

    unless fields.present?
      add_message 'A conta não está configurada para fazer upload de arquivos.'
      set_status :red
    end
  end
end