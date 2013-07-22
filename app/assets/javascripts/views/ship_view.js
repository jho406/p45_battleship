app.Views.ShipView = Backbone.View.extend({
  initialize: function() {
    //jquery UI
    this.$el.draggable({
      snap: ".cell",
      snapMode: "inner",
      snapTolerance: 50,
      stop: function(){
        $(this).addClass("stopped");
      },
      handle: ".handle"
    });

    this.$el.data('model', this.model);
    this.listenTo(this.model, 'detached', this.render);
    this.listenTo(this.model, 'attached', this.render);
    this.render();
  },
  events:{
    'drag':'detach',
    'click .reorient': function(e) {
      e.preventDefault();
      this.reorient();
    }
  },
  detach: function() {
    if (!this.model.cells.at(0)) return;
    var head = this.model.cells.at(0);
    head.detach();
    return head;
  },
  //used to change the orientation of the dropped ship
  reorient: function() {
    var headCell = this.detach(); //to get headCell
    this.model.toggleDirection();
    if (!headCell) return;

    headCell.attach(this.model,
      this.model.get('length'),
      this.model.get('direction'));
  },
  render: function() {
    this.$el.removeClass('detached').removeClass('attached');
    var css = 'detached';
    if (this.model.cells.length>0) css = 'attached';
    this.$el.addClass(css);
  }
});