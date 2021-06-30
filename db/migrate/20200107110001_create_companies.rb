class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :zipcode
      t.string :city
      t.string :logo
      t.string :siret
      t.string :auth_token
      t.timestamps
    end
  end
end
