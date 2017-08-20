class CreateUserAuths < ActiveRecord::Migration[5.0]
  def change
    create_table :user_auths do |t|
      t.string :access_token
      t.string :token_type
      t.string :token_scope
      t.integer :expires_in
      t.string :refresh_token

      t.timestamps
    end
  end
end
