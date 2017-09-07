class AddDefaultValueToRole < ActiveRecord::Migration
    def up
      change_column :users, :role, :string, :default => "customer"
    end

    def down
      change_column :users, :show_attribute, :string, :default => "customer"
    end
end
