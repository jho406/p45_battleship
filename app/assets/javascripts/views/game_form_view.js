app.Views.GameFormView = Backbone.View.extend({
  el:'#new_game',
  initialize: function() {
    this.model = app.game = new app.Models.Game;
    this.listenTo(this.model, 'invalid', this.showErrors);
  },
  events:{
    'submit':'start'
  },
  start: function(e) {
    e.preventDefault();
    var game_attrs = {
      full_name: this.$el.find('#game_full_name').val(),
      email: this.$el.find('#game_email').val()
    };

    game_attrs.deployments_attributes = app.ships.map(function(ship) {
      var data = ship.toJSON();
      data.ship_id = data.id;
      data = _.omit(data,'name', 'id', 'length');
      return data;
    });

    this.model.set(game_attrs);

    if(this.model.isValid()){
      this.model.save([], {silent:true, success:this.openPlay});
    }
  },
  openPlay: function(model, body, options) {
    var resource = options.xhr.getResponseHeader('location');
    app.utils.redirect(resource);
  },
  showErrors: function(model, error) {
    this.$el.find('#notifications').html(error);
  }
});