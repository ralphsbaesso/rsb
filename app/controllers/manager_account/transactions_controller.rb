class ManagerAccount::TransactionsController < AuthenticatorController
  before_action :set_transaction, only: [:show, :update, :destroy]

  def index
    transporter = facade.select ManagerAccount::Transaction

    if transporter.status_green?
      render json: transporter.to_data(:items, json_optons: { include: [:ma_item, :ma_account, :ma_subitem]})
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  def create
    transaction = ManagerAccount::Transaction.new(transaction_parameter)
    transaction.au = current_ac
    transporter = facade.insert transaction

    if transporter.status == :green
      render json: transporter.to_data
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: { data: @transaction }
  end

  def destroy
    transporter = facade.delete @transaction
    return if transporter.status == :green

    render json: { errors: transporter.messages }, status: :unprocessable_entity
  end

  def update
    @transaction.assign_attributes(transaction_parameter)
    transporter = facade.insert @transaction

    if transporter.status == :green
      render json: transporter.to_data
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  private

  def transaction_parameter
    params.require(:transaction).permit(%i[id
                                           amount
                                           description
                                           origin
                                           pay_date
                                           price_cents
                                           status
                                           transaction_date
                                           created_at
                                           updated_at
                                           ma_account_id
                                           ma_item_id
                                           ma_subitem_id])
  end

  def set_transaction
    @transaction = ManagerAccount::Transaction.find params[:id]
  end
end
