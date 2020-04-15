class CreateShippingAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :shipping_addresses do |t|

      t.integer :customer_id, null: false
      t.string :address_name, null: false
      t.string :postal_code, null: false
      t.string :address, null: false
      t.timestamps
    end
  end
end
