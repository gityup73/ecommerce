class AddLineItemToLineItems < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :line_item_total, :decimal
  end
end
