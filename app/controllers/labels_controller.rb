class LabelsController < AuthenticatorController
  before_action :set_label, only: [:update, :destroy]

  def index
    facade = build_facade.select :label, filter: params_to_hash

    if facade.status_green?
      render json: to_data(resource: facade.data)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def create
    label = Label.new(label_parameter)
    label.account_user = current_account_user
    facade = build_facade.insert label

    if facade.status_green?
      render json: to_data(data: label)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def update
    @label.assign_attributes(label_parameter)
    facade = build_facade.insert @label

    if facade.status_green?
      render json: to_data(data: @label)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def destroy
    facade = build_facade.delete @label

    if facade.status_green?
      render json: to_data(data: @label)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def set_resources
    resources = params[:resources]
    app = params[:app]
    labels = params[:labels]

    facade = build_facade.set_resources :label, labels: labels, resources: resources, app: app

    if facade.status_green?
      render json: to_data(data: { labels: labels, resources: resources })
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end

  end

  private

  def label_parameter
    params.require(:label).permit(:name, :app, :color, :background_color)
  end

  def set_label
    @label = current_account_user.labels.find params[:id]
  end

end