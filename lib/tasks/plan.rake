require "csv"

namespace :plan do
  csv_dir = Rails.root.join("lib/assets")
  directory csv_dir

  desc "Import plans from csv"
  task import: :environment do
    ActiveRecord::Base.transaction do
      csv_file = "#{csv_dir}/plan.csv"
      CSV.foreach(csv_file, headers: true, skip_blanks: true).with_index do |row, index|
        plan = Plan.find_or_initialize_by(provider_id: row["provider_id"], name: row["name"])
        raise "Plan の保存に失敗しました（#{index + 2}行目）。" unless plan.save
      end
    end
  end
end
