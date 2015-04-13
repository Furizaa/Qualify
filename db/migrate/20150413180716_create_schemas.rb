class CreateSchemas < ActiveRecord::Migration
  def change
    create_table :schemas do |t|
      t.string :name, limit: 64
      t.string :uuid, limit: 32

      t.timestamps null: false
    end
    add_index :schemas, :uuid, unique: true
  end
end
