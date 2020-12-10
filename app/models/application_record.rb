class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def as_json(options = nil)
    j = super
    j['klass'] = self.class.name
    j
  end

  def public_url(attach_name)
    attach = attach_name.is_a?(ActiveStorage::Attachment) ? attach_name : self.send(attach_name)
    # return nil unless attach.attached?

    if Rails.env.production?
      attach.service_url
    else
      Rails.application.routes.url_helpers.rails_blob_url(attach)
    end
  end


end
