class AccidentsController < ApplicationController

  def index
  end

  def warn_level
    longitude = params[:longitude]
    latitude = params[:latitude]
    query = latitude + ', ' + longitude
    zip_code = ""
    Geocoder.search(query).first.data["address_components"].each do |data|
      if data["types"][0] == "postal_code"
        zip_code = data["short_name"]
      end
    end
    local_accidents = Accident.within_year_and_zipcode(zip_code)
    accidents_within_radius = local_accidents.within_radius(200, latitude.to_f, longitude.to_f)
    accidents_length = accidents_within_radius.length
    if accidents_length > 75
      render json: {warning: 'red', accidents_count: accidents_length}
    elsif accidents_length > 50 && accidents_length < 75
      render json: {warning: 'orange', accidents_count: accidents_length}
    elsif accidents_length > 20 && accidents_length < 50 
      render json: {warning: 'yellow', accidents_count: accidents_length}
    else
      render json: {warning: 'green', accidents_count: accidents_length}
    end
  end 

end