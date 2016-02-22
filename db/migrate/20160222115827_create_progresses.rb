class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.references :step, index: true
      t.references :reviewer, index: true

      t.timestamps
    end
  end
end
