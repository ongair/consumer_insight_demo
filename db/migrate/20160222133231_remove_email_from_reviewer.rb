class RemoveEmailFromReviewer < ActiveRecord::Migration
  def change
  	remove_column :reviewers, :email, :string
  	remove_column :reviewers, :phone_number, :string
  	remove_column :reviewers, :gender, :string
  end
end
