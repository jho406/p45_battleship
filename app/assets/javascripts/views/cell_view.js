//the view on the new game page where we drop a ship and
//auto populate the board.
app.Views.CellView = Backbone.View.extend({
  initialize: function() {
    //jquery ui stuff
    this.$el.droppable({ tolerance: "pointer"});
    this.render();
    this.listenTo(this.model, 'change', this.render);
  },
  events: {
    //we want to handle event stuff in a function of its own
    //and delegate to the actual implementation. Makes testing
    //easier.
    "drop": function(e, obj) {
      var item = obj.draggable.data('model');
      this.attachDropped(item);
    }
  },
  attachDropped: function(item) {
    this.model.attach(item, item.get('length'), item.get('direction'));
  },
  presenter: function() {
    var defaultPresenter = {};
    var ship = this.model.get('ship');
    if (ship){
      _.extend(defaultPresenter, ship.toJSON());
      defaultPresenter.shortName = defaultPresenter.name[0];
    }
    return  defaultPresenter;
  },
  render: function() {
    this.$el.html(HoganTemplates['cell'].render(this.presenter()));
  }
});