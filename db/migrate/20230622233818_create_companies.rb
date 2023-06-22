class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :corporate_name, limit: 100, null: false
      t.string :fantasy_name, limit: 100, null: false
      t.string :email, limit: 100, null: false
      t.string :domain, limit: 50, null: false
      t.string :cnpj, limit: 14, null: false
      t.integer :status, null: false, default: 1
      t.string :token

      t.timestamps
    end
    add_index :companies, :token, unique: true
    add_index :companies, :email, unique: true
    add_index :companies, :domain, unique: true
    add_index :companies, :cnpj, unique: true
    add_index :companies, :status
  end
end
