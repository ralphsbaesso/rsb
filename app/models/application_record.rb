class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def as_json(options = nil)
    j = super
    j['klass'] = self.class.name
    j
  end
end
