class AddColumnsToMergeRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :merge_requests, :idd, :integer
    add_column :merge_requests, :occured_at, :datetime
    add_column :merge_requests, :actor, :string
  end
end
