class AddCustomFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :gender, :string
    add_column :users, :address, :string
    add_column :users, :api_token, :string
    add_column :users, :role, :string
    add_column :users, :dob, :string

  end
end
