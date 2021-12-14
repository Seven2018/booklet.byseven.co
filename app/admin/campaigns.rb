ActiveAdmin.register Campaign do

  show do
    attributes_table do
      row :title
      row :description
      row :owner_id
      row :company_id
      row :interview_form_id
      row :stats
      # row :stats do |resource|
      #   resource.stats
      # end
    end
  end

  permit_params :title, :description, :owner_id, :company_id, :interview_form_id
end
