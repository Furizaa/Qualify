class AddUuidToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :uuid, :string, limit: 32
    add_index :accounts, :uuid, unique: true
  end
end
