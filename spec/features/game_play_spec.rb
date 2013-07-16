require "spec_helper"

describe "On the game play page", :js=>true  do
  let(:game) { create(:game) }

  it 'should create 2 turns when attacking' do
    MockPlatform.any_instance.stub(:counter_nuke=>{:x=>0, :y=>0})
    visit game_path(game)
    expect(page).to have_selector('#attack-board .cell', :count => 100)
    positions = page.all('#attack-board .cell')

    expect{
      positions[0].click
      expect(page).to have_selector '.inactive'
      expect(page).to have_selector '.hit,.miss'
    }.to change{Turn.count}.by(2)
  end

  it 'should show [some status]x2 if the platform fires at the same position' do
    MockPlatform.any_instance.stub(:counter_nuke=>{:x=>1, :y=>0})
    visit game_path(game)
    expect(page).to have_selector('#attack-board .cell', :count => 100)
    page.all('#attack-board .cell')[0].click
    expect(page).to have_selector('.inactive')
      expect(page).to have_selector '.hit,.miss'
    page.all('#attack-board .cell')[1].click

    expect(page).to have_content 'x2'
  end

  it 'should show a roadblock if game over' do
    game.win!
    visit game_path(game)
    expect(page).to have_selector('#attack-board .cell', :count => 100)

    expect(page).to have_text('Game Over') #not specific enough
  end

  it "should not allow clicks on cells that have been clicked" do
    visit game_path(game)
    expect(page).to have_selector('#attack-board .cell', :count => 100)
    positions = page.all('#attack-board .cell')
    positions[0].click
    expect(page).to have_selector('#attack-board .cell.inactive', :count => 1)
  end
end