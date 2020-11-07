module HasLabels
  extend ActiveSupport::Concern

  included do
    has_many :associated_labels, as: :owner
    has_many :labels, through: :associated_labels
  end
end