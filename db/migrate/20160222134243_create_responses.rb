class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.text :text
      t.references :reviewer, index: true
      t.references :question, index: true

      t.timestamps
    end
  end
end
