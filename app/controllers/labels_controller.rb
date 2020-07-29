class LabelsController < AuthenticatorController
  before_action :set_label, only: [:update, :destroy]

  def index
    render json: { data: current_account_user.labels.where(app: params[:app]) }
  end

  def create
    label = Label.new(label_parameter)
    label.account_user = current_account_user
    transporter = facade.insert label

    if transporter.status == :green
      render json: transporter.to_data
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  def update
    @label.assign_attributes(label_parameter)
    transporter = facade.insert @label

    if transporter.status == :green
      render json: transporter.to_data
    else
      render json: { errors: transporter.messages }, status: :unprocessable_entity
    end
  end

  def set_resources
    pp params

    render json: :ok
  end

  private

  def label_parameter
    params.require(:label).permit(:name, :app, :color, :background_color)
  end

  def set_label
    @label = current_account_user.labels.find params[:id]
  end

end