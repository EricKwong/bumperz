class AddIndexToAccidents < ActiveRecord::Migration
  def change
    def up
      add_earthdistance_index :accidents
    end

    def down
      remove_earthdistance_index :accidents
    end
  end
end
