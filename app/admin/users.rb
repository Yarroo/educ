ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :username, user_role_ids: []

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :user_roles
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :user_roles,  as: :check_boxes, collection: UserRole.pluck(:name, :id)
    end
    f.actions
  end

end
