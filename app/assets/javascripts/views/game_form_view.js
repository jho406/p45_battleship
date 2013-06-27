app.Views.GameFormView = Backbone.View.extend({
  el:'#new_game',
  initialize: function(){

  },
  events:{
    'submit':'start'
  },
  start: function(e){
    e.preventDefault();
    var game_attr = {
      full_name: this.$el.find('#game_full_name').val(),
      email: this.$el.find('#game_email').val()
    };

    game_attr.deployments_attributes = app.ships.map(function(ship){
      var data = ship.toJSON();
      data.ship_id = data.id;
      data = _.omit(data,'name', 'id', 'length');
      return data;
    });

    app.game = new app.Models.Game(game_attr);
    app.game.save();
  }
});