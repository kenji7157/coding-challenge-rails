module Api
  module V1
    class PlansController < ApplicationController
      def index
        ampere = params[:ampere]
        kwh = params[:kwh]
        response = [] 

        # TODO: preloadちゃんと調べる
        Plan.preload(:basic_charges).find_each do |plan|
      
          # 1. 基本料金を計算
          target_basic_charge = plan.basic_charges.find do |basic_charge|
            basic_charge.ampere == ampere
          end
          # NOTE: ここでnextを実行することによって、該当する契約容量を持たないプランはレスポンス候補から外れる
          if target_basic_charge.blank?
            next
          end
          basic_charge = target_basic_charge.charge

          # 2. 従量料金を計算
          total_commodity_charge = 0
          diff_kwh = 0
          plan.commodity_charges.sort_by(&:kwh_from).each do |commodity_charge|
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
          
          simulation_result = {
            provider_name: plan.provider.name,
            plan_name: plan.name,
            price: basic_charge + total_commodity_charge,
          }

          response.push(simulation_result)
        end


        render json: response, status: :ok
      end
    end
  end
end
