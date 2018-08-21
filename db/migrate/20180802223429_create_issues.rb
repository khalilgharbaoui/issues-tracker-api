class CreateIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :issues do |t|
      t.string :title
      t.references :user
      t.string :assigned_to, default: ""
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
