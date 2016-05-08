class Accident < ActiveRecord::Base
  acts_as_geolocated latitude: 'latitude_column_name', longitude: 'longitude_column_name'

  scope :within_year_and_zipcode, ->(zipcode) {
    where(:date => Date.today.last_year..Date.today, :zip_code => zipcode)
  }
end