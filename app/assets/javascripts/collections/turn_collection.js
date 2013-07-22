app.Collections.TurnCollection = Backbone.Collection.extend({
  model: app.Models.Turn,
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

    //we need to re-fetch on sync, this is due to the gaming platform
    //aka the opponent. creating a turn of its own which won't be reflected
    // through a model sync.
    this.listenTo(this, 'sync', function(model, resp, options) {
      if(options.xhr.status == 201){
        this.fetch();
      }
    });
  },
  _setupUrl: function() {
    this.url = function(){
      return this.parent.urlRoot + '/' + this.parent.id + '/turns'
    };
  }
});