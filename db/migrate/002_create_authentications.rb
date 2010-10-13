class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table(:authentications) do |t|
      t.integer :user_id
      t.string :uid, :limit => 32
      t.string :provider, :limit => 32
      t.timestamps
    end
    add_index :authentications, :user_id
    add_index :authentications, :uid
    add_index :authentications, :provider
  end

  def self.down
    drop_table :authentications
  end
end
