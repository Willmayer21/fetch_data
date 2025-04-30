class FixColumnName < ActiveRecord::Migration[8.0]
  def change
    rename_column :events, :event_type, :type
  end
end
