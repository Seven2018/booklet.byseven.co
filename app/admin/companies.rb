ActiveAdmin.register Company do
  index do
    column :id
    column :name
    column :address
    column :zipcode
    column :city
    column :siret
    column :applications
    actions
  end


  form html: { multipart: true } do |f|
    tabs do
      tab 'Gnal' do
        f.inputs do
          f.input :name
          f.input :address
          f.input :zipcode
          f.input :city
          f.input :logo
          f.input :siret
          f.input :auth_token
          f.input :applications, as: :check_boxes, collection: Company::APPLICATIONS.keys.map{ |k, _v| [k, k] }
        end
      end

      tab 'Assets' do
        f.input(:home_banner, as: :file,
          hint: f.object.home_banner_meta(:desktop).hint)
        div do
          if f.object.home_banner.attached?
            cl_image_tag(f.object.home_banner.key, crop: :fit, gravity: :center,
              width: f.object.home_banner_meta(:desktop).width,
              height: f.object.home_banner_meta(:desktop).height)
          end
        end

        f.input(:my_interviews_banner, as: :file,
          hint: f.object.my_interviews_banner_meta(:desktop).hint)
        div do
          if f.object.my_interviews_banner.attached?
            cl_image_tag(f.object.my_interviews_banner.key, crop: :fit, gravity: :center,
              width: f.object.my_interviews_banner_meta(:desktop).width,
              height: f.object.my_interviews_banner_meta(:desktop).height)
          end
        end

        f.input(:my_team_interviews_banner, as: :file,
          hint: f.object.my_team_interviews_banner_meta(:desktop).hint)
        div do
          if f.object.my_team_interviews_banner.attached?
            cl_image_tag(f.object.my_team_interviews_banner.key, crop: :fit, gravity: :center,
              width: f.object.my_team_interviews_banner_meta(:desktop).width,
              height: f.object.my_team_interviews_banner_meta(:desktop).height)
          end
        end

        f.input(:campaign_banner, as: :file,
          hint: f.object.campaign_banner_meta(:desktop).hint)
        div do
          if f.object.campaign_banner.attached?
            cl_image_tag(f.object.campaign_banner.key, crop: :fit, gravity: :center,
              width: f.object.campaign_banner_meta(:desktop).width,
              height: f.object.campaign_banner_meta(:desktop).height)
          end
        end

        f.input(:clear_bg_logo, as: :file,
          hint: f.object.clear_bg_logo_meta(:desktop).hint)
        div do
          if f.object.clear_bg_logo.attached?
            cl_image_tag(f.object.clear_bg_logo.key, crop: :fit, gravity: :center,
              width: f.object.clear_bg_logo_meta(:desktop).width,
              height: f.object.clear_bg_logo_meta(:desktop).height)
          end
        end

        f.input(:dark_bg_logo, as: :file,
          hint: f.object.dark_bg_logo_meta(:desktop).hint)
        div do
          if f.object.dark_bg_logo.attached?
            cl_image_tag(f.object.dark_bg_logo.key, crop: :fit, gravity: :center,
              width: f.object.dark_bg_logo_meta(:desktop).width,
              height: f.object.dark_bg_logo_meta(:desktop).height)
          end
        end

        f.input(:my_interviews_bg_picture, as: :file,
          hint: f.object.my_interviews_bg_picture_meta(:desktop).hint)
        div do
          if f.object.my_interviews_bg_picture.attached?
            cl_image_tag(f.object.my_interviews_bg_picture.key, crop: :fit, gravity: :center,
              width: f.object.my_interviews_bg_picture_meta(:desktop).width,
              height: f.object.my_interviews_bg_picture_meta(:desktop).height)
          end
        end

        f.input(:my_team_interviews_bg_picture, as: :file,
          hint: f.object.my_team_interviews_bg_picture_meta(:desktop).hint)
        div do
          if f.object.my_team_interviews_bg_picture.attached?
            cl_image_tag(f.object.my_team_interviews_bg_picture.key, crop: :fit, gravity: :center,
              width: f.object.my_team_interviews_bg_picture_meta(:desktop).width,
              height: f.object.my_team_interviews_bg_picture_meta(:desktop).height)
          end
        end

        f.input(:my_trainings_bg_picture, as: :file,
          hint: f.object.my_trainings_bg_picture_meta(:desktop).hint)
        div do
          if f.object.my_trainings_bg_picture.attached?
            cl_image_tag(f.object.my_trainings_bg_picture.key, crop: :fit, gravity: :center,
              width: f.object.my_trainings_bg_picture_meta(:desktop).width,
              height: f.object.my_trainings_bg_picture_meta(:desktop).height)
          end
        end

        f.input(:my_team_trainings_bg_picture, as: :file,
          hint: f.object.my_team_trainings_bg_picture_meta(:desktop).hint)
        div do
          if f.object.my_team_trainings_bg_picture.attached?
            cl_image_tag(f.object.my_team_trainings_bg_picture.key, crop: :fit, gravity: :center,
              width: f.object.my_team_trainings_bg_picture_meta(:desktop).width,
              height: f.object.my_team_trainings_bg_picture_meta(:desktop).height)
          end
        end

        f.input :rating_logo
      end
    end

    f.actions
  end

  permit_params :name, :address, :zipcode, :city, :logo, :siret, :auth_token,
    :home_banner,
    :my_interviews_banner,
    :my_team_interviews_banner,
    :campaign_banner,
    :clear_bg_logo, :dark_bg_logo,
    :my_interviews_bg_picture, :my_team_interviews_bg_picture,
    :my_trainings_bg_picture, :my_team_trainings_bg_picture, :rating_logo,
    applications: []
end
