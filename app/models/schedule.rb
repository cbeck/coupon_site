class Schedule < ActiveRecord::Base
  belongs_to :business
  
  DAYS = { 1 => 'sunday', 2 => 'monday', 3 => 'tuesday', 4 => 'wednesday', 
    5 => 'thursday', 6 => 'friday', 7 => 'saturday' }
  
  # def initialize(*args)
  #   super(*args)
  # end
  
  def to_google
    unless omit?
      DAYS.collect do |ord, day|
        unless send("#{day}_closed")
          [ord, send("#{day}_open"), send("#{day}_open_period"), 
                send("#{day}_close"), send("#{day}_close_period")].join(':')
        end
      end.reject{|item| item.nil?}.sort.join(',')
    end
  end

  def self.default
    s = Schedule.new
    # DAYS.values.each do |day|
    %w[monday tuesday wednesday thursday friday saturday sunday].each do |day|
      s.send("#{day}_open=", "9:00")
      s.send("#{day}_open_period=", "AM")
      s.send("#{day}_close=", "7:00")
      s.send("#{day}_close_period=", "PM")
    end
    s.sunday_closed = true
    s.saturday_closed = true
    s
  end

  def open_at(day, use24=false)
    open = send("#{day}_open")
    period = send("#{day}_open_period")
    unless open.nil? || period.nil?
      if use24
        hour24 open, period
      else
        open + " " + period
      end
    end
  end

  def close_at(day, use24=false)
    close = send("#{day}_close")
    period = send("#{day}_close_period")
    unless close.nil? || period.nil?
      if use24
        hour24 close, period
      else
        close + " " + period
      end
    end
  end
  
  def closed?(day)
    (send("#{day}_closed")==true || open_at(day).nil? || close_at(day).nil?)
  end
    
  def to_s(day)
    (closed?(day)) ? "closed" : "#{open_at(day)} - #{close_at(day)}"
  end
  
  def self.parse_to_params(str)
    schedule = str.split(/,\s*/).inject({}) do | sched, dstr|
      hours = parse_to_day_params(dstr)
      (hours.nil?) ? sched : sched.merge(hours)
    end
  end

  def self.parse_to_day_params(str)    
    if str =~ /(\d):closed/i
      day = DAYS[$1.to_i]
      { "#{day}_closed"=>"1" }.symbolize_keys!
    elsif str =~ /(\d):(\d{1,2}):(\d{2}):(\d{1,2}):(\d{2})/
      day = DAYS[$1.to_i]
      { "#{day}_open"=>"#{$2.to_i % 12}:#{$3}", "#{day}_open_period"=>"#{($2.to_i <= 12) ? 'AM' : 'PM'}", 
        "#{day}_close"=>"#{$4.to_i % 12}:#{$5}", "#{day}_close_period"=>"#{($4.to_i <= 12) ? 'AM' : 'PM'}", 
        "#{day}_closed"=>"0"}.symbolize_keys!
    else
      nil
    #   raise "invalid schedule encoding: #{str}"
    end
  end
  
  private  
  def hour12(time)
    unless time.blank?
      # parts = time.split(":")
      hour, min = time.split ':'
      return "NA" if min.nil?
      if hour.to_i <= 12
        sprintf "%s:%s AM", hour, min
      else
        sprintf "%02d:%s PM", hour.to_i-12, min
      end
    end
  end
  
  def hour24(time, period)
    if period == "PM"
      hour, min = time.split ':'
      return "NA" if min.nil?
      hour = hour.to_i + 12 if hour.to_i < 12
      time = sprintf "%s:%s", hour, min
    end
    time
  end

end
