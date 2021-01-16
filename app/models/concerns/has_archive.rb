module HasArchive
  extend ActiveSupport::Concern

  included do
    has_one :archive, as: :owner, dependent: :delete
    before_save { archive&.save }
  end

  def attach(file, filename: nil, extension: nil)
    file =
      if file.is_a?(File)
        file
      elsif File.file?(file)
        File.open(file, 'rb')
      else
        raise 'Must past one valid File'
      end

    content = file.read
    self.archive ||= build_archive

    archive.content = Base64.encode64(Zlib::Deflate.deflate(content))
    archive.md5 = Digest::MD5.hexdigest(content)
    archive.extension = extension || File.extname(file.path)
    archive.filename = filename || File.basename(file.path, archive.extension)
    archive.size = File.size(file)
  end

  def attachment
    return nil if archive.nil?

    dir = Rails.root.join('tmp', 'archives', Rails.env, self.class.name.underscore)
    FileUtils.mkdir_p(dir)
    path = File.join(dir, archive.full_name)
    File.open(path, 'wb') { |f| f.write(Zlib::Inflate.inflate(Base64.decode64(archive.content))) }
    File.open(path, 'rb')
  end

  def attach?
    archive.present?
  end

  def save_attach
    archive&.save
  end

  def purge_attach
    self.archive = nil if archive&.destroy
  end

  def archive_base64
    Base64.encode64(Zlib::Inflate.inflate(Base64.decode64(archive.content)))
  end

  def filesize
    archive.size
  end

end
