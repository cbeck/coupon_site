class CorrectBadUrls < ActiveRecord::Migration
  def self.up
    websites = Website.all
    websites.each {|w| w.save}
  end

  def self.down
    #nichts
  end
end
