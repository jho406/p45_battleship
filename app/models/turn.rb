class Turn < ActiveRecord::Base
  belongs_to :game

  attr_accessible :position, :attacked, :status

  validates :position, :presence => true
  validates :position, :uniqueness => { :scope => [:game_id, :attacked]}
  before_save :update_game_if_won

  private

  def update_game_if_won
    if self.status == 'lost'
      self.game.win!
    end
  end
end
