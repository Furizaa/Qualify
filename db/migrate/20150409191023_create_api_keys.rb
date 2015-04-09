class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :key, limit: 32
      t.belongs_to :account, index: true

      t.timestamps null: false
    end
    add_index :api_keys, :key, unique: true
  end
end
