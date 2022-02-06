class CreateUserPushMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :user_push_messages do |t|
      t.integer :status
      t.integer :user_id
      t.integer :push_message_id
      t.timestamps
    end
  end
end
