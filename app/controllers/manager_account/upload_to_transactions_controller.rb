class ManagerAccount::UploadToTransactionsController < AuthenticatorController

  def index
    render json: { data: ManagerAccount::Structure.description_options }
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
