class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.text :text
      t.references :question, index: true

      t.timestamps
    end
  end
end
