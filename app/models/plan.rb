class Plan < ApplicationRecord
  belongs_to :provider, foreign_key: "provider_id"
  has_many :basic_charges, dependent: :destroy, foreign_key: "plan_id"
  has_many :commodity_charges, dependent: :destroy, foreign_key: "plan_id"

  validates :provider_id, presence: true
  validates :name, presence: true

  def basic_charge_by(ampere)
    target_basic_charge = self.basic_charges.find do |basic_charge|
      basic_charge.ampere == ampere
    end
    basic_charge = target_basic_charge.blank? ? nil : target_basic_charge.charge
  end
end
