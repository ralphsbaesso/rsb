class BAM::TransactionsController < AuthenticatorController
  before_action :set_transaction, only: [:show, :update, :destroy]

  def index
    associations = %i[labels bam_item bam_category bam_account]
    facade = build_facade.select BAM::Transaction, filter: params_to_hash

    if facade.status_green?
      render json: to_data(resource: facade.data) { |resource|
        resource.includes(associations) .as_json(include: associations)
      }
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def create
    transaction = BAM::Transaction.new(transaction_parameter)
    transaction.au = current_ac
    facade = build_facade.insert transaction

    if facade.status_green?
      render json: to_data(data: transaction)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def show
    render json: to_data(data: @transaction)
  end

  def destroy
    facade = build_facade.delete @transaction

    if facade.status_green?
      render json: to_data(data: @transaction)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def update
    @transaction.assign_attributes(transaction_parameter)
    facade = build_facade.update @transaction

    if facade.status_green?
      render json: to_data(data: @transaction)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  private

  def transaction_parameter
    params.require(:transaction)
          .permit(%i[id
                     amount
                     description
                     origin
                     pay_date
                     price
                     status
                     transaction_date
                     bam_account_id
                     bam_item_id
                     bam_category_id])
  end

  def set_transaction
    @transaction = BAM::Transaction.find params[:id]
  end
end
