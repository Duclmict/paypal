class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :salary
      t.boolean :status
      t.string :pay_account

      t.timestamps
    end
  end
end
