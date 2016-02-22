class CreateReviewers < ActiveRecord::Migration
  def change
    create_table :reviewers do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :gender
      t.string :telegram_id

      t.timestamps
    end
  end
end
