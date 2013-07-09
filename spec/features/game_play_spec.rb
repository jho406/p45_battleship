require "spec_helper"

describe "On the game play page", :js=>true  do
  let(:game) { create(:game) }

  it 'should create 2 turns when attacking' do
    visit game_path(game)
    expect(page).to have_selector('#attack-board .cell', :count => 100)
    positions = page.all('#attack-board .cell')

    expect{
      positions[0].click
      expect(page).to have_content 'hit'
    }.to change{Turn.count}.by(2)
  end

  it 'should show a roadblock if game over' do
    game.win!
    visit game_path(game)
    expect(page).to have_selector('#attack-board .cell', :count => 100)

    #todo: the bottom won't be necessary when we refactor
    page.execute_script("app.game.fetch();")
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