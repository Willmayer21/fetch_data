class AddColumnsToMergeRequest < ActiveRecord::Migration[8.0]
  def change
    add_column :merge_requests, :number, :integer
    add_column :merge_requests, :state, :string
    add_column :merge_requests, :status, :string
  end
end
