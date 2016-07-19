class CreateCodeTables < ActiveRecord::Migration
  def change
    create_table :code_tables do |t|
      t.string :type
      t.integer :code
      t.string :value

      t.timestamps null: false
    end
  end
end
