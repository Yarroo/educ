class CreateUserUserRoles < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :user_roles
  end
end
