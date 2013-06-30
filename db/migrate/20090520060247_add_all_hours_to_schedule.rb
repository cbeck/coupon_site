class AddAllHoursToSchedule < ActiveRecord::Migration
  def self.up
    add_column :schedules, :all_hours, :boolean
  end

  def self.down
    remove_column :schedules, :all_hours
  end
end
