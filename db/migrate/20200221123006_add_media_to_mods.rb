class AddMediaToMods < ActiveRecord::Migration[6.0]
  def change
    add_column :mods, :media, :string
  end
end
