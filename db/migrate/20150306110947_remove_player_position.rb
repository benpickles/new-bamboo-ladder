class RemovePlayerPosition < ActiveRecord::Migration
  def change
    remove_column :players, :position, :integer
  end
end
