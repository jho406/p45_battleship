
app.Views.CellView = Backbone.View.extend({
  initialize: function(){
    this.$el.droppable({ tolerance: "pointer"});
    this.render();
    this.listenTo(this.model, 'change', this.render);
  },
  events: {
    "drop": 'attachDropped'
  },
  attachDropped: function(e, obj){
    item = obj.draggable.data('model')

    var self = this;
    // var cells = this.model.andAdjacentCells(
    //   item.get('length'), item.get('orientation'));
    this.model.attach(item, item.get('length'), item.get('orientation'));
    //todo: might want to extract the collision detecting in its own method.
    // var isCollision = !!_.find(cells, function(cell){
    //   return !!cell.get("ship");
    // });

    // if (isCollision){
    //   this.trigger('collided', this);
    //   return false;
    // }

    // _.each(cells, function(cell){
    //   item.cells.push(cell)
    //   cell.set('ship', item);
    // });
  },
  presenter: function(){
    var defaultPresenter = {};
    var ship = this.model.get('ship');
    if (ship){
      _.extend(defaultPresenter, ship.toJSON());
      defaultPresenter.shortName = defaultPresenter.name[0];
    }
    return  defaultPresenter;
  },
  render: function(){
    this.$el.html(HoganTemplates['cell'].render(this.presenter()));
  }
});