class AddTypeToMod < ActiveRecord::Migration[6.0]
  def change
    add_column :mods, :type, :string
  end
end
