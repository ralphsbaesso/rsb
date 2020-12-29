class BAM::TransactionsController < AuthenticatorController
  before_action :set_transaction, only: [:show, :update, :destroy, :upload, :remove_file]

  def index
    option_json = { include: associations }
    option_json[:method] = :files unless params_to_hash[:without_meta]

    facade = build_facade.select BAM::Transaction, filter: params_to_hash

    if facade.status_green?
      render json: to_data(resource: facade.data, **params_to_hash) { |resource|
        resource.includes(associations).as_json(option_json)
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

  def upload
    files = params.dig(:transaction, :files)
    if files.present?
      @transaction.attaches.attach(files)
      @transaction.save
    end
    render json: to_data(data: @transaction.as_json(methods: :files))
  end

  def remove_file
    index = params[:index].to_i
    @transaction.attaches[index].purge
    @transaction.reload
    render json: to_data(data: @transaction.as_json(methods: :files))
  end

  def show
    json = @transaction.as_json(method: :files, include: associations)
    render json: to_data(data: json)
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
                     paid_at
                     price
                     status
                     annotation
                     transacted_at
                     bam_account_id
                     bam_item_id
                     bam_category_id])
  end

  def set_transaction
    @transaction = BAM::Transaction.find params[:id]
  end

  def associations
    %i[labels bam_item bam_category bam_account]
  end
end
