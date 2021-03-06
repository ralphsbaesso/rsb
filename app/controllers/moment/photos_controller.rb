# frozen_string_literal: true

class Moment::PhotosController < AuthenticatorController
  before_action :set_moment_photo, only: %i[show update destroy]

  def index
    facade = build_facade.select 'Moment::Photo', filter: params_to_hash

    if facade.status_green?
      render json: to_data(resource: facade.data) { |r| r.includes(:archive, :labels).as_json(include: :labels, methods: %i[name archive_base64 filesize extension]) }
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def create
    moment_photo = Moment::Photo.new
    file = params.dig(:moment_photo, :file)&.tempfile
    filename = params.dig(:moment_photo, :file)&.original_filename
    moment_photo.attach(file, filename: filename)
    moment_photo.au = current_ac
    facade = build_facade.insert moment_photo

    if facade.status_green?
      render json: to_data(data: moment_photo)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def show
    render json: { data: @moment_photo }
  end

  def destroy
    facade = build_facade.delete @moment_photo
    if facade.status_green?
      render json: to_data(data: @moment_photo)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  def update
    @moment_photo.assign_attributes(moment_photo_parameter)
    facade = build_facade.update @moment_photo

    if facade.status_green?
      render json: to_data(data: @moment_photo)
    else
      render json: to_data(errors: facade.errors), status: :unprocessable_entity
    end
  end

  private

  def moment_photo_parameter
    params.require(:photo).permit(:name, :description)
  end

  def set_moment_photo
    @moment_photo = Moment::Photo.find params[:id]
  end
end
