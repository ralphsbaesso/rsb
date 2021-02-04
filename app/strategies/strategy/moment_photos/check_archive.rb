# frozen_string_literal: true

class Strategy::MomentPhotos::CheckArchive < Strategy
  desc 'Verifica se é um arquivo válido'
  def process
    photo = model

    unless photo.attach?
      add_error 'Deve passar um arquivo'
      set_status :red
      return
    end

    extension = photo.extension
    return if %w[jpg jpeg gif png apng svg bmp bmp ico png ico].include?(extension.downcase)

    add_error 'Extensão inválida.'
    set_status :red
  end
end
