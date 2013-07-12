app.Collections.CellCollection = Backbone.Collection.extend({
  model: app.Models.Cell,
  meshify: function(len) {
    //Create the references
    for (var i = 0, l = this.length-1; i <= l; i++) {
      var top = this.at(i-len) || null,
          bottom = this.at(i+len) || null,
          left = this.at(i-1) || null,
          right = this.at(i+1) || null;

      //Removes the right reference if we're at the right edge.
      if(((i+1)%len) == 0){
        right = null;
      }

      //Removes the left reference if we're at the left edge.
      if(((i)%len) == 0){
        left = null;
      }

      //Set the siblings
      this.at(i).siblings = {
        top:    top,
        right:  right,
        bottom: bottom,
        left:   left
      };
    };
    return this;
  },
  add: function(models, options) {
    //todo: has one fix
    if (!_.isArray(models)) models = models ? [models] : [];

    var self = this;
    _.each(models, function(m){
      if (m instanceof Backbone.Model) {
        m.set('ship', self.ship || null);
      }else {
        m.ship = self.ship || null;
      }
    });

    return Backbone.Collection.prototype.add.call(this, models, options);
  }
});