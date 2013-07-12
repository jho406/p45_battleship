app.Collections.DeploymentCollection = Backbone.Collection.extend({
  model: app.Models.Deployment,
  initialize: function(attrs) {

    if (attrs.parent) {
      this.url = function(){
        return this.parent.urlRoot + '/' + this.parent.id + '/deployments'
      };

      this.parent = attrs.parent;
      this.listenTo(this.parent, 'change', function(){
        if(this.parent.isNew()) return;
        this.fetch();
      });
    };
  }
});