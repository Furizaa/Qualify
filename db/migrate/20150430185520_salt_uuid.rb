class SaltUuid < ActiveRecord::Migration
  def change
    change_column :accounts, :salt, :string, :limit => 36
  end
end
