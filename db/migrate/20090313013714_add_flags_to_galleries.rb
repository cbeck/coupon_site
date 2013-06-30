class AddFlagsToGalleries < ActiveRecord::Migration
  def self.up
    change_table :galleries do |t|
      t.boolean :has_logos
      t.boolean :enabled
    end
    
    Gallery.reset_column_information
    
    logo_gal = Gallery.find_by_name('Logos')
    logo_gal.update_attribute(:has_logos, true) unless logo_gal.nil?
    
    Gallery.update_all('enabled = 1')
  end

  def self.down
    change_table :galleries do |t|
      t.boolean :has_logos
      t.boolean :enabled
    end 
  end
end
