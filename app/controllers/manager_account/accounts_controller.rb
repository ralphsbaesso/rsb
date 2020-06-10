class ManagerAccount::AccountsController < AuthenticatorController
  before_action :set_account, only: [:show, :update, :destroy]

  def index
    transporter = facade.select MA::Account

    if transporter.status_green?
      render json: transporter.to_data(:items)
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  def create
    account = MA::Account.new(account_parameter)
    account.ac = current_ac
    transporter = facade.insert account

    if transporter.status == :green
      render json: transporter.to_data
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: { data: @account }
  end

  def destroy
    transporter = facade.delete @account
    return if transporter.status == :green

    render json: { errors: transporter.messages }, status: :unprocessable_entity
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

  private

  def account_parameter
    params.require(:account).permit(:name, :description)
  end

  def set_account
    @account = MA::Account.find params[:id]
  end
end
