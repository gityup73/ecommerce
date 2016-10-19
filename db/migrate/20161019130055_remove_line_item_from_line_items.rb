class RemoveLineItemFromLineItems < ActiveRecord::Migration[5.0]
  def change
    remove_column :line_items, :line_item, :decimal
  end
end
