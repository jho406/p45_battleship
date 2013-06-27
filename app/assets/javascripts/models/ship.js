app.Models.Ship = Backbone.Model.extend({
  hasMany:{
    cells: 'CellCollection'
  },
  initialize: function(){
    var self = this;
    _.each(self.hasMany, function(collection,  name){
      self[name] = new app.Collections[collection]([], {'hasOne':{'ship': self}});
    });
  },
  defaults:{
    'orientation':'right'
  },
  toggleOrientation: function(){
    var orien = this.get('orientation');
    orien = orien == 'right' ? 'bottom' : 'right';
    this.set('orientation', orien);
    return this
  },
  positions: function(){
    return this.cells.map(function(obj){
      return obj.get('position');
    });
  },
  toJSON: function(){
    var json = _.clone(this.attributes);
    json.positions = [this.positions()[0]];
    return json;
  }
});
