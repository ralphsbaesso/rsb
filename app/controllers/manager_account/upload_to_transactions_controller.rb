class BAM::UploadToTransactionsController < AuthenticatorController

  def index
    render json: { data: BAM::Structure.description_options }
  end

  def create
    pp params
  end

  def show
  end

  def destroy
  end

  def update
  end

end
