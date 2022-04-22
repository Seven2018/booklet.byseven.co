class AddRatingLogoToCompany < ActiveRecord::Migration[6.0]
  def up
    add_column :companies, :rating_logo, :text, default: '<span class="iconify" data-icon="clarity:star-solid"></span>'
  end
end
