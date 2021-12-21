ActiveAdmin.register User do
  actions :index, :show, :update, :edit, :destroy

  filter :email
  filter :firstname
  filter :lastname
  filter :job_title
  filter :company, as: :select, collection: Company.pluck(:name, :id)
  filter :access_level, as: :select, collection: User::ACCESS_LEVELS

  index do
    selectable_column
    id_column
    column :email
    column :firstname
    column :lastname
    column :job_title
    column :company
    column :access_level
    actions
  end


  show do
    attributes_table do
      row :email
      row :firstname
      row :lastname
      row :job_title
      row :company_id
      row :access_level
      row :social_security
      row :gender
      row :birth_date
      row :hire_date
      row :address
      row :phone_number
      row :linkedin
      row :picture
      row :encrypted_password
      row :reset_password_token
      row :reset_password_sent_at
      row :remember_created_at
      row :authentication_token
    end
  end


  form do |f|
    f.inputs do
      f.input :email
      f.input :firstname
      f.input :lastname
      f.input :job_title
      f.input :company, as: :select, collection: Company.pluck(:name, :id), include_blank: false
      f.input :access_level, as: :select, collection: User::ACCESS_LEVELS, include_blank: false
      f.input :social_security
      f.input :gender
      f.input :birth_date
      f.input :hire_date
      f.input :address
      f.input :phone_number
      f.input :linkedin
      f.input :picture
      # f.input :encrypted_password
      # f.input :reset_password_token
      # f.input :reset_password_sent_at
      # f.input :remember_created_at
      # f.input :authentication_token
    end
    f.actions
  end


  permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :firstname, :lastname, :birth_date, :hire_date, :authentication_token, :address, :phone_number, :social_security, :gender, :job_title, :linkedin, :picture, :access_level, :company_id
end
