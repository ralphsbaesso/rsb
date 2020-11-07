class BAM::TransactionsController < AuthenticatorController
  before_action :set_transaction, only: [:show, :update, :destroy]

  def index
    facade = build_facade.select BAM::Transaction

    if facade.status_green?
      render json: to_data(resource: facade.data) { |resource|
        resource.includes(:bam_item, :bam_account, :bam_category)
                .as_json(include: [:bam_item, :bam_account, :bam_category])
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
                     price_cents
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
