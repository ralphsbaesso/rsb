class BAM::UploadToTransactionsController < AuthenticatorController

  def index
    render json: { data: BAM::Structure.description_options }
  end

  def create
    attributes = {
      bam_account: BAM::Account.find(params.dig(:upload_to_transaction, :bam_account_id)),
      file: params.dig(:upload_to_transaction, :file)&.tempfile,
      paid_at: params.dig(:upload_to_transaction, :paid_at)
    }

    upload_to_transaction = BAM::UploadToTransaction.new(attributes)
    facade = build_facade.insert upload_to_transaction

    if facade.status_green?
      render json: to_data(data: upload_to_transaction)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
  end

  def update
  end

end
