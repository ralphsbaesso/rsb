class Strategy::BAMUploadToTransactions::CheckAttributes < Strategy

  def process
    upload = model
    errors = []

    errors << 'Deve passar um arquivo válido.' unless File.file?(upload.file)
    errors << 'Deve passar uma conta válida.' unless upload.bam_account.is_a?(BAM::Account)

    return unless errors.present?

    add_error errors
    set_status :red
  end

end