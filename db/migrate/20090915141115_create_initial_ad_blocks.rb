class CreateInitialAdBlocks < ActiveRecord::Migration
  def self.up
    # creating initial ad block for home page. More will be added later at Marc's direction. This is really the proof of concept.
    AdBlock.create :location => "home_footer_1", :available_placements => 4, :orientation => "horizontal", :columns => 4
  end

  def self.down
    block = AdBlock.find_by_location('home_footer_1')
    block.destroy
  end
end
