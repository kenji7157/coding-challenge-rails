class Provider < ApplicationRecord
  has_many :plans, dependent: :destroy, foreign_key: "provider_id"

  validates :name, presence: true
end
