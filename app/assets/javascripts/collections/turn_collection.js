app.Collections.TurnCollection = Backbone.Collection.extend({
  model: app.Models.Turn,
  initialize: function(attrs) {

    if (attrs.parent) {
      this.url = function(){
        return this.parent.urlRoot + '/' + this.parent.id + '/turns'
      };

      this.parent = attrs.parent;
      this.listenTo(this.parent, 'change', function(){
        if(this.parent.isNew()) return;
        this.fetch();
      });
    };

    this.listenTo(this, 'sync', function(model, resp, options) {
      if(options.xhr.status == 201){
        this.fetch();
      }
    });
  }
});