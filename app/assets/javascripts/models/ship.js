//represent a model of a ship to be placed on a board on the new game page.
app.Models.Ship = Backbone.Model.extend({
  initialize: function() {
    this.cells = new app.Collections.CellCollection();
  },
  defaults: {
    'direction':'right'
  },
  toggleDirection: function() {
    var direction = this.get('direction');
    direction = direction == 'right' ? 'bottom' : 'right';
    this.set('direction', direction);
    return this;
  },
  positions: function() {
    return this.cells.map(function(obj){
      return obj.get('position');
    });
  },
  toJSON: function(){
    var json = _.clone(this.attributes);

    if (_.contains(['left', 'right'], json.direction)) {
      json.orientation = 'horizontal';
    } else {
      json.orientation = 'vertical';
    }
    delete json.direction;

    var first = this.positions()[0];
    json.positions = first >= 0 ? [first] : [];
    return json;
  }
});
