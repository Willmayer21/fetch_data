class AddColumnsToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :iid, :integer
    add_column :events, :actor, :string
    add_column :events, :occured_at, :datetime
  end
end
