class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.references :merge_request, foreign_key: true
      t.string :event_type
      t.timestamps
    end
  end
end
