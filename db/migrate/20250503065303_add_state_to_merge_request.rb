class AddStateToMergeRequest < ActiveRecord::Migration[8.0]
  def change
    add_column :merge_requests, :state, :string
  end
end
