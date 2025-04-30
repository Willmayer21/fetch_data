class RemoveColumnsFromMergeRequests < ActiveRecord::Migration[8.0]
  def change
    remove_column :merge_requests, :state
    remove_column :merge_requests, :status
    remove_column :merge_requests, :number
  end
end
