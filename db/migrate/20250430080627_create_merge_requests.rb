class CreateMergeRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :merge_requests do |t|
      t.timestamps
    end
  end
end
