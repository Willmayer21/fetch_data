class RemoveColumnToNote < ActiveRecord::Migration[8.0]
  def change
    remove_column :notes, :note_id
  end
end
