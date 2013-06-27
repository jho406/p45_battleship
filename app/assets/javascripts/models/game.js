app.Models.Game = Backbone.Model.extend({
  url: '/games',
  paramRoot: 'game',
  initialize: function(){
    this.turns = new app.Collections.TurnCollection;
    this.turns.url = '/game/' + this.id + '/turns';

    this.deployments = new app.Collections.DeploymentCollection;
    this.deployments.url = '/game/' + this.id + '/deployments';
   }
});
