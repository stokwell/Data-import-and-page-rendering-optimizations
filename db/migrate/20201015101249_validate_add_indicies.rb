class ValidateAddIndicies < ActiveRecord::Migration[5.2]
  def change
    validate_foreign_key :trips, :buses
  end
end
