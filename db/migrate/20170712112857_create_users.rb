class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :password_hash, null: false
      t.integer :phone
      t.datetime :birth_date
      t.text :education
      t.string :english
      t.text :experience
      t.text :portfolio
      t.boolean :have_a_job, default: false
      t.string :preferable_pet

      t.timestamps null: false
    end
  end
end
