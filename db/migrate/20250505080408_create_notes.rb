class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.references :merge_request
      t.integer :project_id
      t.integer :iid
      t.string :event
      t.string :body
      t.integer :note_id
      t.string :author
      t.datetime :occured_at
      t.timestamps
    end
  end
end
