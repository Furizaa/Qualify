class AddAccountRefToSchemas < ActiveRecord::Migration
  def change
    add_reference :schemas, :account, index: true, foreign_key: true
  end
end
