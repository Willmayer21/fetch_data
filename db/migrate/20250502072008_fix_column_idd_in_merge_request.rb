class FixColumnIddInMergeRequest < ActiveRecord::Migration[8.0]
  def change
    rename_column :merge_requests, :idd, :iid
  end
end
