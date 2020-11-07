class CreatePoems < ActiveRecord::Migration[6.0]
  def change
    create_table :poems do |t|
      t.references :user, null: false, foreign_key: true
      t.string :author
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
