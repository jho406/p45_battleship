//belongs to a game
app.Collections.DeploymentCollection = Backbone.Collection.extend({
  model: app.Models.Deployment,
  initialize: function(attrs) {

    if (attrs.parent) {
      this._setupUrl();
      this.parent = attrs.parent;
      //update itself when game changed. this usually means a hit was
      //successful
      this.listenTo(this.parent, 'change', function(){
        if(this.parent.isNew()) return;
        this.fetch();
      });
    };
  },
  _setupUrl: function(){
    this.url = function(){
      return this.parent.urlRoot + '/' + this.parent.id + '/deployments'
    };
  }
});