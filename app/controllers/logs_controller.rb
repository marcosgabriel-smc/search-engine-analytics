class LogsController < ApplicationController
  def create
    @log = Log.new(log_params)

    unless valid_input?(@log.input) && valid_ip?(@log.ip)
      render json: { error: 'Invalid input or IP address' }, status: :unprocessable_entity
      return
    end

    api_key = ENV['GEO_LOCATION_API']
    response = HTTParty.get("https://api.ipgeolocation.io/ipgeo?apiKey=#{api_key}&ip=#{@log.ip}")
    location_data = response.parsed_response
    country = location_data['country_name']
    @log.country = country

    if @log.save
      render json: @log, status: :created
    else
      render json: @log.errors, status: :unprocessable_entity
    end
  end

  private
  def log_params
    params.require(:log).permit(:input, :ip)
  end

  def valid_input?(input)
    input.present? && input.length >= 3
  end

  def valid_ip?(ip)
    !!(/\A(?:[0-9]{1,3}\.){3}[0-9]{1,3}\z/.match(ip))
  end

end
