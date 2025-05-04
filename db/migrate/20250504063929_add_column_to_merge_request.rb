class AddColumnToMergeRequest < ActiveRecord::Migration[8.0]
  def change
    add_column :merge_requests, :project_id, :integer
  end
end
