class AddReferenceToEvent < ActiveRecord::Migration[8.0]
  def change
    add_reference :events, :note, index: true
  end
end
