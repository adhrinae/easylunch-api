class ChangeCodeTableColumn < ActiveRecord::Migration
  def change
    rename_column :code_tables, :type, :code_type
  end
end
