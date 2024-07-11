class Log < ApplicationRecord
  ip_regex = /\A(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\z/
  validates :input, presence: true, length: {minimum: 3}
  validates :ip, presence: true, format: { with: ip_regex, message: "must be a valid IPv4 address" }
  validates :country, presence: true
  validates :is_processed, inclusion: { in: [true, false] }

  def self.top_five_inputs
    where(is_processed: true)
      .group(:input)
      .select('input, COUNT(*) as count')
      .order('count DESC')
      .limit(5)
  end

  def self.perform_log_processing
    users_unprocessed_logs = where(is_processed: false).order(:created_at).group_by(&:ip)

    users_filtered_logs = users_unprocessed_logs.transform_values { |logs| filter_logs(logs) }

    logs_ids = users_filtered_logs.values.flatten.map(&:id)

    where(id: logs_ids).update_all(is_processed: true)

    bad_logs_ids = where(is_processed: false).map(&:id)

    where(id: bad_logs_ids).delete_all
  end

  private_class_method def self.filter_logs(logs)
    final_inputs = []
    current_input = ""

    logs.each_with_index do |log, index|
      if index == 0 || log.input.start_with?(current_input)
        current_input = log.input
      else
        final_inputs << log
        current_input = log.input
      end
    end
    final_inputs << logs.last
    final_inputs
  end
end
