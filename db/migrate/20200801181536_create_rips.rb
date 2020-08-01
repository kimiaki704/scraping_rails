class CreateRips < ActiveRecord::Migration[6.0]
  def change
    create_table :rips do |t|
      t.string :product_id
      t.string :name
      t.string :description
      t.string :category_display_name
      t.string :category_name
      t.string :image_url
      t.string :brand_name
      t.string :price
      t.string :size_and_price

      t.timestamps
    end
    
    add_index :rips, :product_id, :unique => true
  end
end
