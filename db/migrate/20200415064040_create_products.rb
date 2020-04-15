class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|

      t.string :product_name, null: false
      t.text :product_description, null: false
      t.integer :genre_id, null: false
      t.boolean :sale_status, null: false, default: false
      t.string :image_id, null: false
      t.integer :tax_included_price, null: false
      t.timestamps
    end
  end
end
