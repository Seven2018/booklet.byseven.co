ActiveAdmin.register Interview do
  filter :campaign_id
  filter :creator_id
  # filter :creator, as: :select, collection: User.pluck(:email, :id)
  filter :title


  permit_params :title, :description, :completed, :label, :date, :starts_at, :ends_at,
    :interview_form_id, :employee_id, :creator_id, :campaign_id
end
