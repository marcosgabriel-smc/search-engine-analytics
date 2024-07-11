class ProcessLogsJob < ApplicationJob
  queue_as :default

  def perform
    # Return a hash where {"ip" => [unprocessed_logs], "ip2" => [unprocessed_logs] (...) }
    users_unprocessed_logs = Log.where(is_processed: false).order(:created_at).group_by(&:ip)

    # Return a hash where {"ip" => [processed_logs], "ip2" => [processed_logs] (...) }
    users_filtered_logs = users_unprocessed_logs.transform_values { |logs| filter_logs(logs) }

    # Return the IDs of the Logs to be updated
    logs_ids = users_filtered_logs.values.flatten.map(&:id)

    # Perform a batch update
    Log.where(id: logs_ids).update_all(is_processed: true)

    # Return the IDs of the Logs to be deleted
    bad_logs_ids = users_unprocessed_logs.values.flatten.reject(&:is_processed).map(&:id)

    # Perform a batch delete
    Log.where(id: bad_logs_ids).delete_all
  end

  private

  def filter_logs(logs)
    final_inputs = []
    current_input = ""

    logs.each_with_index do |log, index|
      if index == 0 || log.input.start_with?(current_input)
        current_input = log.input
      else
        final_inputs << current_input
        current_input = log.input
      end
    end
    final_inputs << current_query
    return final_inputs
  end
end
