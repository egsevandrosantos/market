class CreateCompanyUserInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :company_user_invitations do |t|
      t.references :company, null: false, foreign_key: true
      t.string :user_email, limit: 100, null: false

      t.timestamps
    end
    add_index :company_user_invitations, [:company_id, :user_email], unique: true
  end
end
