class Plan < ApplicationRecord
  belongs_to :provider, foreign_key: "provider_id"
  has_many :basic_charges, dependent: :destroy, foreign_key: "plan_id"
  has_many :commodity_charges, dependent: :destroy, foreign_key: "plan_id"
end
