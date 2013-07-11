app.Models.Game = Backbone.Model.extend({
  urlRoot: '/games',
  paramRoot: 'game',
  initialize: function(){
    this.listenTo(this, 'change:over', this.triggerOver)
    this.turns = new app.Collections.TurnCollection;
    this.turns.url = '/games/' + this.id + '/turns';

    this.deployments = new app.Collections.DeploymentCollection;
    this.deployments.url = '/game/' + this.id + '/deployments';
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
