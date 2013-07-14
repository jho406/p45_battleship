require "spec_helper"

describe "The new game page", :js => true do
  before(:each) do
    visit '/'
  end

  let(:positions) { find_by_id('placement-board').all('.cell') }
  let(:ships)     { find_by_id('aresenal').all('.handle') }

  it "should create a game" do
    expect(page).to have_selector('.handle', :count => Ship.count)
    expect{
      fill_in 'game_email', :with => 'user@example.com'
      fill_in 'game_full_name', :with => 'john smith'

      ships.each_with_index do |ship, index|
        ship.drag_to(positions[index * 10])
      end

      click_on 'Create Game'
      expect(page).to have_selector('.cell', :count => 200)
      expect(page).to have_selector '.head'
    }.to change{Game.count}.by(1)
  end

  context "The placement board (droppable)" do
    it "should populate siblings when a ship is dropped on it" do
      ships[0].drag_to(positions[0])
      positions[1].should have_text
    end
  end

  context "A ship (draggable)" do
    it "should change when dragged and dropped" do
      ships[0].drag_to(positions[0])
      ships[0].parent.should have_selector('li.stopped')
    end

    it "should be valid if there's no overlapping ships" do
      ships[0].drag_to(positions[0])
      ships[0].parent.should have_selector('li.attached')
    end

    it "should not be valid if there's an overlapping ship" do
      ships[0].drag_to(positions[0])
      ships[1].drag_to(positions[0])
      ships[1].parent.should have_selector('li.detached')
    end
  end

  context "The form submit button (notifications)" do
    it "should show validation errors when form isn't ready" do
      ships.each_with_index do |ship, index|
        ship.drag_to(positions[index * 10])
      end

      click_on 'Create Game'
      page.find_by_id('notifications').should have_text
    end

    it "should show validation errors when placement-board isn't ready" do
      fill_in 'game_email', :with => 'user@example.com'
      fill_in 'game_full_name', :with => 'john smith'

      click_on 'Create Game'
      page.find_by_id('notifications').should have_text
    end
  end
end