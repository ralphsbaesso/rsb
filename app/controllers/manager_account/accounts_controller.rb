class BAM::AccountsController < AuthenticatorController
  before_action :set_account, only: [:show, :update, :destroy]

  def index
    facade.select 'BAM::Account'

    if facade.status_green?
      render json: facade.to_data(:data)
    else
      render json: { errors: facade.errors }, status: :unprocessable_entity
    end
  end

  def create
    account = BAM::Account.new(account_parameter)
    account.au = current_ac
    facade.insert account

    if facade.status_green?
      render json: facade.to_data
    else
      render json: { errors: facade.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: { data: @account }
  end

  def destroy
    facade.delete @account
    return if facade.status_green?

    render json: { errors: facade.errors }, status: :unprocessable_entity
  end

  def update
    @account.assign_attributes(account_parameter)
    transporter = facade.insert @account

    if transporter.status == :green
      render json: transporter.to_data
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  def field_options
    render json: { data: BAM::Account::FIELDS }
  end

  private

  def account_parameter
    params.require(:account).permit(:name, :description, fields: [])
  end

  def set_account
    @account = BAM::Account.find params[:id]
  end
end
