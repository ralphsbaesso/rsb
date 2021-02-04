# frozen_string_literal: true

class Admin::EventsController < AuthenticatorController
  before_action :set_event, only: %i[update destroy]

  def index
    facade = Facade.new(account_user: current_account_user)
    facade.select :event
    render json: to_data(resource: facade.data) { |resource| resource.order(updated_at: :desc) }
  end

  def create
    event = Label.new(event_parameter)
    event.account_user = current_account_user
    facade.insert event

    if facade.status_green?
      render json: facade.to_data
    else
      render json: { errors: facade.errors }, status: :unprocessable_entity
    end
  end

  def update
    @event.assign_attributes(event_parameter)
    facade.insert @event

    if facade.status_green?
      render json: facade.to_data
    else
      render json: { errors: facade.errors }, status: :unprocessable_entity
    end
  end

  def set_resources
    resources = params[:resources]
    app = params[:app]
    events = params[:events]

    facade.set_resources :event, events: events, resources: resources, app: app
    if facade.status_green?
      render json: :ok
    else
      render json: { errors: facade.errors }
    end
  end

  private

  def event_parameter
    params.require(:event).permit(:name, :app, :color, :background_color)
  end

  def set_event
    @event = current_account_user.events.find params[:id]
  end
end
