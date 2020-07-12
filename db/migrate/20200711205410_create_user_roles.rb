class CreateUserRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :user_roles do |t|
      t.string :name
      t.string :role

      t.timestamps
    end

    UserRole.create(name: "Администратор", role: 'admin')
    UserRole.create(name: "Редактор", role: 'redactor')
    UserRole.create(name: "Пользователь", role: 'user')
  end
end
