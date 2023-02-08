require "csv"

namespace :provider do
  csv_dir = Rails.root.join("lib/assets")
  directory csv_dir

  desc "Import providers from csv"
  task import: :environment do
    ActiveRecord::Base.transaction do
      csv_file = "#{csv_dir}/provider.csv"
      CSV.foreach(csv_file, headers: true, skip_blanks: true).with_index do |row, index|
        provider = Provider.find_or_initialize_by(name: row["name"])
        raise "Provider の保存に失敗しました（#{index + 2}行目）。" unless provider.save
      end
    end
  end
end
