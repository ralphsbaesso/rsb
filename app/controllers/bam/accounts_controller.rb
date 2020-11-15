class BAM::AccountsController < AuthenticatorController
  before_action :set_account, only: [:show, :update, :destroy]

  def index
    facade = build_facade.select 'BAM::Account'

    if facade.status_green?
      render json: to_data(resource: facade.data)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def create
    account = BAM::Account.new(account_parameter)
    account.au = current_ac
    facade = build_facade.insert account

    if facade.status_green?
      render json: to_data(data: account)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def show
    render json: { data: @account }
  end

  def destroy
    facade = build_facade.delete @account
    if facade.status_green?
      render json: to_data(data: @account)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def update
    @account.assign_attributes(account_parameter)
    facade = build_facade.update @account

    if facade.status_green?
      render json: to_data(data: @account)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
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
