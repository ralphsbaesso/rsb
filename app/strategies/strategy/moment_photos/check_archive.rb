class Strategy::MomentPhotos::CheckArchive < Strategy

  desc 'Verifica se é um arquivo válido'
  def process
    photo = model
    file = photo.current_archive

    unless file
      add_error 'Deve passar um arquivo'
      set_status :red
      return
    end

    ext = File.extname(file)
    unless %w[.jpeg .gif .png .apng .svg .bmp .bmp .ico .png .ico].include?(ext.downcase)
      add_error 'Extensão inválida.'
      set_status :red
      return
    end

    begin
      photo.attach(file)
    rescue
      add_error 'Arquivo inválido'
      set_status :red
    end
  end

end