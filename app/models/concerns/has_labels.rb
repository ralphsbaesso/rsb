# frozen_string_literal: true

module HasLabels
  extend ActiveSupport::Concern

  included do
    has_many :associated_labels, as: :owner, dependent: :delete_all
    has_many :labels, through: :associated_labels
  end
end
