class ManagerAccount::SubitemsController < ApplicationController
  before_action :set_subitem, only: [:show, :update, :destroy]

  def index
    transporter = facade.select MA::Subitem, filter_subitem

    if transporter.status_green?
      render json: transporter.to_data(:items)
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  def create
    subitem = MA::Subitem.new(subitem_parameter)
    transporter = facade.insert subitem

    if transporter.status == :green
      render json: transporter.to_data
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: { data: @subitem }
  end

  def destroy
    transporter = facade.delete @subitem
    render json: { errors: transporter.messages }, status: :unprocessable_entity if transporter.status != :green
  end

  def update
    @subitem.assign_attributes(subitem_parameter)
    transporter = facade.insert @subitem

    if transporter.status == :green
      render json: transporter.to_data
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  private

  def subitem_parameter
    params.require(:subitem).permit(:name, :description, :item_id)
  end

  def set_subitem
    @subitem = MA::Subitem.find params[:id]
  end

  def filter_subitem
    { filter: params }
  end
end
