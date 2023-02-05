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

  def commodity_charge_by(kwh)
    total_commodity_charge = 0
    diff_kwh = 0
    self.commodity_charges.sort_by(&:kwh_from).each do |commodity_charge|
      max_kwh = commodity_charge.kwh_to || 99999999
      min_kwh = commodity_charge.kwh_from || 0
      charge = commodity_charge.charge

      if min_kwh >= kwh
        next
      elsif max_kwh >= kwh && kwh > min_kwh 
        diff_kwh = kwh - min_kwh
      else kwh > max_kwh
        diff_kwh = max_kwh
      end

      total_commodity_charge = total_commodity_charge + charge * diff_kwh
    end
    total_commodity_charge
  end
end
