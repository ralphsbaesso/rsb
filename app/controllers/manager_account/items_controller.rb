class ManagerAccount::ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:show, :update, :destroy]

  def index
    transporter = facade.select MA::Item

    if transporter.status_green?
      render json: transporter.to_data(:items)
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  def create
    item = MA::Item.new(item_parameter)
    item.ac = current_ac
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
    @item = MA::Item.find params[:id]
  end
end
