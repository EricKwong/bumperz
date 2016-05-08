require 'csv'

namespace :csv do

  desc "Import Accident Data CSV"
  task :import_accidents => :environment do

    csv_file_path = 'lib/seeds/nyc_accident_data.csv'

    CSV.foreach(csv_file_path, {:headers => true}) do |row|
      if row[4] && row[5]
        Accident.create!({
          :date => row[0],
          :time => row[1],
          :borough => row[2],        
          :zip_code => row[3],        
          :latitude => row[4],        
          :longitude => row[5],
          :on_street => row[7],        
          :cross_street => row[8],        
          :injured => row[10],        
          :killed => row[11]        
        })
      end
      puts "Row added!"
    end
  end
end