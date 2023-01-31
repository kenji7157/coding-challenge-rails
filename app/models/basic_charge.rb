class BasicCharge < ApplicationRecord
  belongs_to :plan, foreign_key: "plan_id"

  validates :plan_id, presence: true
  validates :ampere, presence: true
  validates :charge, presence: true
end
