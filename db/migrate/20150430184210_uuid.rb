class Uuid < ActiveRecord::Migration
  def change
    change_column :accounts, :uuid, :string, :limit => 36
    change_column :api_keys, :key, :string, :limit => 36
    change_column :schemas, :uuid, :string, :limit => 36
  end
end
