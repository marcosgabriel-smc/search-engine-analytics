class CreateLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :logs do |t|
      t.string :input
      t.string :ip
      t.string :country

      t.timestamps
    end
  end
end
