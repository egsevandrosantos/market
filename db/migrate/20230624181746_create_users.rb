class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :full_name, limit: 100, null: false
      t.string :cpf, limit: 11, null: false
      t.string :email, limit: 100, null: false
      t.string :password_digest
      t.references :company, null: false, foreign_key: true
      t.string :token
      t.integer :status, null: false, default: 1

      t.timestamps
    end
    add_index :users, :token, unique: true
    add_index :users, :status
    add_index :users, [:cpf, :company_id], unique: true
    add_index :users, [:email, :company_id], unique: true
  end
end
