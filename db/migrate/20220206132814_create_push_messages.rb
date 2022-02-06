class CreatePushMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :push_messages do |t|
      t.text :description
      t.text :title
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
