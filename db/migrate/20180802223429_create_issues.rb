class CreateIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :issues do |t|
      t.string :title
      t.string :created_by
      t.string :assigned_to, null: true
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
