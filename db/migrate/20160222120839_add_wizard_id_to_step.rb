class AddWizardIdToStep < ActiveRecord::Migration
  def change
    add_reference :steps, :wizard, index: true
  end
end
