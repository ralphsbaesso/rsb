class BAM::ItemsController < AuthenticatorController
  before_action :set_item, only: [:show, :update, :destroy]

  def index
    facade.select BAM::Item

    if facade.status_green?
      render json: facade.to_data(:data, json_options: { include: :labels})
    else
      render json: { errors: facade.errors }, status: :unprocessable_entity
    end
  end

  def create
    item = BAM::Item.new(item_parameter)
    item.au = current_ac
    transporter = facade.insert item

    if transporter.status == :green
      render json: transporter.to_data
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: { data: @item }
  end

  def destroy
    transporter = facade.delete @item
    return if transporter.status == :green

    render json: { errors: transporter.messages }, status: :unprocessable_entity
  end

  def update
    @item.assign_attributes(item_parameter)
    transporter = facade.insert @item

    if transporter.status == :green
      render json: transporter.to_data
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
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
