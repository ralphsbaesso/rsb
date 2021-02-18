# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def as_json(options = nil)
    j = super
    j['klass'] = self.class.name
    j
  end

  def public_url(attach_name, **options)
    attach =
      if attach_name.is_a?(ActiveStorage::Attached::One) || attach_name.is_a?(ActiveStorage::Attachment)
        attach_name
      else
        self.send(attach_name)
      end

    return if attach.respond_to?(:attached?) && !attach.attached?

    if options[:expires_in].present?
      attach.service_url expires_in: options[:expires_in]
    else
      Rails.application.routes.url_helpers.rails_blob_url(attach)
    end
  end
end
