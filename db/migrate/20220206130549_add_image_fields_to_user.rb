class AddImageFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :profile_img, :string
    add_column :users, :cover_img, :string  
  end
end
