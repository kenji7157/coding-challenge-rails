require 'csv'

namespace :basic_charge do

  csv_dir = Rails.root.join("lib/assets")
  directory csv_dir

  desc "Import basic_charges from csv"
  task import: :environment do
    ActiveRecord::Base.transaction do
      csv_file = "#{csv_dir}/basic_charge.csv"
      CSV.foreach(csv_file, headers: true, skip_blanks: true).with_index do |row, index|
        basic_charge = BasicCharge.find_or_initialize_by(plan_id: row["plan_id"], ampere: row["ampere"], charge: row["charge"])
        unless basic_charge.save
          raise "BasicCharge の保存に失敗しました（#{index + 2}行目）。"
        end
      end 
    end
  end

end