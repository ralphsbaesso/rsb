class BAM::ItemsController < AuthenticatorController
  before_action :set_item, only: [:show, :update, :destroy]

  def index
    facade = build_facade.select BAM::Item

    if facade.status_green?
      render json: to_data(resource: facade.data, **params_to_hash)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def create
    item = BAM::Item.new(item_parameter)
    item.au = current_ac
    facade = build_facade.insert item

    if facade.status == :green
      render json: to_data(data: item)
    else
      render json: { errors: facade.messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: to_data(data: @item)
  end

  def destroy
    facade = build_facade.delete @item

    if facade.status_green?
      render json: to_data(data: @item)
    else
      render json: { errors: facade.errors }, status: :unprocessable_entity
    end
  end

  def update
    @item.assign_attributes(item_parameter)
    facade = build_facade.update @item

    if facade.status_green?
      render json: to_data(data: @item)
    else
      render json: { errors: facade.errors }, status: :unprocessable_entity
    end
  end

  private

  def item_parameter
    params.require(:item).permit(:name, :description)
  end

  def set_item
    @item = BAM::Item.find params[:id]
  end
end
