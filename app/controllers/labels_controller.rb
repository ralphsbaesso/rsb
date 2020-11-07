class LabelsController < AuthenticatorController
  before_action :set_label, only: [:update, :destroy]

  def index
    pp params
    puts '<>' * 100
    render json:{}# { data: current_account_user.labels.where(app: params[:app]) }
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