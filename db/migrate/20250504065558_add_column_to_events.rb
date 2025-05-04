class AddColumnToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :project_id, :integer
  end
end
