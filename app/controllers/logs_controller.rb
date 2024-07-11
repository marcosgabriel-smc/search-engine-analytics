class LogsController < ApplicationController
  def create
    @log = Log.new(log_params)
    api_key = ENV['GEO_LOCATION_API']
    response = HTTParty.get("https://api.ipgeolocation.io/ipgeo?apiKey=#{api_key}&ip=#{@log.ip}")
    location_data = response.parsed_response
    city = location_data['city']
    country = location_data['country_name']
    @log.city = city
    @log.country = country

    @log.save

    # render json: @log
  end

  private
  def log_params
    params.require(:log).permit(:input, :ip)
  end
end
