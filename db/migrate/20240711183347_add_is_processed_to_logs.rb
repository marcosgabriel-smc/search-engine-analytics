class AddIsProcessedToLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :logs, :is_processed, :boolean, default: false
  end
end
