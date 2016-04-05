class AddCharmaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :charma, :integer, :null => false, :default => 1
  end
end
