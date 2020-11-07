class BAM::CategoriesController < AuthenticatorController
  before_action :set_category, only: [:show, :update, :destroy]

  def index
    facade = build_facade.select 'BAM::Category'

    if facade.status_green?
      render json: to_data(resource: facade.data)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def create
    category = BAM::Category.new(category_parameter)
    category.au = current_ac
    facade = build_facade.insert category

    if facade.status_green?
      render json: to_data(data: category)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def show
    render json: { data: @category }
  end

  def destroy
    facade = build_facade.delete @category

    if facade.status_green?
      render json: to_data(data: @category)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def update
    @category.assign_attributes(category_parameter)
    facade = build_facade.update @category

    if facade.status_green?
      render json: to_data(data: @category)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  private

  def category_parameter
    params.require(:category).permit(:name, :description, :level)
  end

  def set_category
    @category = BAM::Category.find params[:id]
  end
end
