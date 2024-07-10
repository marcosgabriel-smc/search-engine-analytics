class RemovePgTrgmExtensionFromDb < ActiveRecord::Migration[7.1]
  def change
    disable_extension 'pg_trgm'
  end
end
