# frozen_string_literal: true

class Strategy::MomentPhotos::CheckUnique < Strategy
  desc 'Verifica se já existe Foto nesta conta'
  def process
    digest = model.archive.md5
    photo_existed = Moment::Photo.includes(:archive)
                                 .where(
                                   account_user: current_account_user,
                                   archives: { md5: digest }
                                 ).first

    return unless photo_existed

    add_error 'Foto já existe nesta conta.'
    set_status :red
    if photo_existed.name
      add_error "Nome: #{photo_existed.name}"
    else
      add_error "Criado em #{photo_existed.created_at.strftime('%Y/%m/%d %H:%M')} e atualizado em #{photo_existed.updated_at.strftime('%Y/%m/%d %H:%M')}"
    end
  end
end
