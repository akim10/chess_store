class AddDefaultValueToPicture < ActiveRecord::Migration
    def up
      change_column :items, :picture, :string, :default => "placeholder.png"
    end

    def down
      change_column :items, :show_attribute, :string, :default => "placeholder.png"
    end
end
