class CreateUserDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :user_devices do |t|
      t.text :push_token
      t.boolean :is_active, default: true
      t.references :user
      t.timestamps
    end
  end
end
