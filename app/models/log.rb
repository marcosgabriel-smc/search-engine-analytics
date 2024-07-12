class Log < ApplicationRecord
  ip_regex = /\A(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\z/
  validates :input, presence: true, length: {minimum: 3}
  validates :ip, presence: true, format: { with: ip_regex, message: "must be a valid IPv4 address" }
  validates :is_processed, inclusion: { in: [true, false] }

  def self.top_five_inputs
    where(is_processed: true)
      .group(:input)
      .select('input, COUNT(*) as count')
      .order('count DESC')
      .limit(5)
  end

  def self.latest_logs
    where(is_processed: true)
      .order(created_at: :desc)
      .limit(5)
  end

  def self.top_users
    where(is_processed: true)
      .group(:ip)
      .order('count_id DESC')
      .limit(5)
      .count(:id)
  end

  def self.logs_by_country
    where(is_processed: true)
      .group(:country)
      .count
  end



  def self.perform_log_processing
    users_unprocessed_logs = where(is_processed: false).order(:created_at).group_by(&:ip)

    users_filtered_logs = users_unprocessed_logs.transform_values { |logs| filter_logs(logs) }

    logs_ids = users_filtered_logs.values.flatten.map(&:id)

    where(id: logs_ids).update_all(is_processed: true)

    bad_logs_ids = where(is_processed: false).map(&:id)

    where(id: bad_logs_ids).delete_all
  end

    # Mock Array
    # logs = ["Banana", "App", "Apple", "Apple Juice", "Oran", "Orange"]
    # Expected result: ["Banana", "Apple Juice", "Orange"]

  private_class_method def self.filter_logs(logs)
    final_inputs = []
    current_log = logs.first

    logs.each_with_index do |log, index|
      next_log = logs[index + 1]
      if next_log && next_log.input.start_with?(current_log.input)
        current_log = next_log
      else
        final_inputs << current_log unless final_inputs.include?(current_log)
        current_log = next_log
      end
    end
    final_inputs
  end
end
