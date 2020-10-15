class AddIndicies < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :buses_services, [:bus_id, :service_id], unique: true, algorithm: :concurrently

    add_foreign_key :trips, :buses, validate: false, on_delete: :cascade
    add_foreign_key :trips, :cities, column: :from_id, validate: false, on_delete: :cascade
    add_foreign_key :trips, :cities, column: :to_id, validate: false, on_delete: :cascade

    add_index :trips, :bus_id, algorithm: :concurrently
    add_index :trips, :from_id, algorithm: :concurrently
    add_index :trips, :to_id, algorithm: :concurrently
    add_index :trips, :start_time, algorithm: :concurrently
  end
end
