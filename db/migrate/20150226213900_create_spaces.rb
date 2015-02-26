class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.integer :board_id
      t.string :state
      t.string :letter
      t.string :number

      t.timestamps null: false
    end
    add_index :spaces, :letter
    add_index :spaces, :number
    add_index :spaces, :board_id

  end
end
