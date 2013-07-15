//the main game model, there's only one of this per game.
app.Models.Game = Backbone.Model.extend({
  urlRoot: '/api/games',
  paramRoot: 'game',
  initialize: function(){
    var self = this;
    this.listenTo(this, 'change:over', this.triggerOver)

    //create the child relationships
    this.turns = new app.Collections.TurnCollection({parent: this});
    this.deployments = new app.Collections.DeploymentCollection({parent: this});

    this.listenTo(this.turns, 'sync', this.fetchSelf);
  },
  //we only want to fetch when 2 turns have been created.
  fetchSelf: function() {
    if (this.turns.length % 2 == 0){
      this.fetch();
    };
  },
  validate: function(attrs, options){
    var error;
    if (error = this.validate_positions(attrs.deployments_attributes)) return error;
    if (error = this.validate_email(attrs.email)) return error;
    if (error = this.validate_full_name(attrs.full_name)) return error;
  },
  validate_positions: function(positions){
    var bad_pos = _.any(positions, function(ship) {
      return ship.positions.length != 1
    });

    if (bad_pos) return "not all ships have been deployed";
  },
  validate_full_name: function(full_name) {
    if (!full_name || full_name.length <=0) return "missing name";
  },
  validate_email: function(email) {
    if (!email || email.length <=0) return "missing email";
  },
  triggerOver: function(model, value) {
    if (value) this.trigger('over');
  }
});
