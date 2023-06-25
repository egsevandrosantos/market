class AddTokenToCompanyUserInvitation < ActiveRecord::Migration[7.0]
  def change
    add_column :company_user_invitations, :token, :string
    add_index :company_user_invitations, :token, unique: true
  end
end
