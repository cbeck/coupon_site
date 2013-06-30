class CreateSchedule < ActiveRecord::Migration
  def self.up
    create_table "schedules", :force => true do |t|
      t.integer  "business_id"
      t.string   "sunday_open"
      t.string   "sunday_close"
      t.string   "monday_open"
      t.string   "monday_close"
      t.string   "tuesday_open"
      t.string   "tuesday_close"
      t.string   "wednesday_open"
      t.string   "wednesday_close"
      t.string   "thursday_open"
      t.string   "thursday_close"
      t.string   "friday_open"
      t.string   "friday_close"
      t.string   "saturday_open"
      t.string   "saturday_close"
      t.string   "holidays"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "sunday_open_period"
      t.string   "sunday_close_period"
      t.boolean  "sunday_closed"
      t.string   "monday_open_period"
      t.string   "monday_close_period"
      t.boolean  "monday_closed"
      t.string   "tuesday_open_period"
      t.string   "tuesday_close_period"
      t.boolean  "tuesday_closed"
      t.string   "wednesday_open_period"
      t.string   "wednesday_close_period"
      t.boolean  "wednesday_closed"
      t.string   "thursday_open_period"
      t.string   "thursday_close_period"
      t.boolean  "thursday_closed"
      t.string   "friday_open_period"
      t.string   "friday_close_period"
      t.boolean  "friday_closed"
      t.string   "saturday_open_period"
      t.string   "saturday_close_period"
      t.boolean  "saturday_closed"
      t.boolean  "omit"
    end

    add_index "schedules", ["business_id"], :name => "index_schedules_on_business_id"
    
    remove_column :businesses, :schedule
    
    Business.all.each do |b|
      b.schedule = Schedule.default
      b.save
    end
  end

  def self.down
    add_column :businesses, :schedule, :string
    drop_table :schedules
  end
end
