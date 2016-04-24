class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.references :user, index: true, foreign_key: false
      t.references :project, index: true, foreign_key: false
      t.datetime :begun_at
      t.datetime :ended_at

      t.timestamps null: false
    end
  end
end
