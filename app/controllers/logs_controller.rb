class LogsController < ApplicationController
  def create
    @log = Log.new(log_params)

    unless valid_input?(@log.input) && valid_ip?(@log.ip)
      render json: { error: 'Invalid input or IP address' }, status: :unprocessable_entity
      return
    end

    if @log.save
      render json: @log, status: :created
    else
      render json: @log.errors, status: :unprocessable_entity
    end
  end

  def filter_logs
    Log.perform_log_processing
    api_key = ENV['GEO_LOCATION_API']

    pending_country_logs = Log.where(is_processed: true, country: nil)

    pending_country_logs.each do |log|
      response = HTTParty.get("https://api.ipgeolocation.io/ipgeo?apiKey=#{api_key}&ip=#{log.ip}")
      if response.success?
        location_data = response.parsed_response
        country = location_data['country_name']
        log.update(country: country)
      end
    end

    redirect_to articles_path
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
