app.Views.AresenalView = Backbone.View.extend({
  el: '#aresenal',
  initialize: function() {
    this.listenTo(this.collection, 'reset', this.render);
  },
  children: [],
  childView: 'ShipView',
  presenter: function() {
    var ships = _.map(this.collection.toJSON(), function(obj) {
      obj.shortName = obj.name[0];
      return obj;
    })
    return {ships: ships};
  },
  render: function() {
    this.$el.html(
      HoganTemplates['aresenal'].render(this.presenter())
    );
    var self = this;
    this.attachChildViews(this.$el.find('.ship'));
  },
  attachChildViews: function(els) {
    var self = this;
    _.each(els, function(el, index) {
      var view = new app.Views[self.childView]({el:el, model: self.collection.at(index)});
      self.children.push(view);
    });
  }
});
