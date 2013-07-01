app.Models.Game = Backbone.Model.extend({
  url: '/games',
  paramRoot: 'game',
  initialize: function(){
    this.turns = new app.Collections.TurnCollection;
    this.turns.url = '/games/' + this.id + '/turns';

    this.deployments = new app.Collections.DeploymentCollection;
    this.deployments.url = '/game/' + this.id + '/deployments';
   },
  validate: function(attrs, options){
    //all deployments have a position
    var bad_pos = _.any(attrs.deployments_attributes, function(ship){
      return ship.positions.length != 1
    });

    if (bad_pos) return "not all ships have been deployed";

    //todo: refactor to own methods
    var bad_string = _.any([attrs.full_name, attrs.email],function(str){
      return !(attrs.full_name && attrs.full_name.length>0)
    })

    if (bad_string) return "strings are empty or nil";

  }
});
