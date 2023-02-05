module Api
  module V1
    class PlansController < ApplicationController
      def index
        ampere = params[:ampere]
        kwh = params[:kwh]
        response = [] 

        Plan.preload(:basic_charges).find_each do |plan|      
          # 1. 基本料金を計算
          basic_charge = plan.basic_charge_by(ampere)
          # NOTE: ここでnextを実行することによって、該当する契約容量を持たないプランはレスポンス候補から外れる
          if basic_charge.blank?
            next
          end

          # 2. 従量料金を計算
          total_commodity_charge = plan.commodity_charge_by(kwh)
          
          # 3. レスポンスのオブジェクトを生成 
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
