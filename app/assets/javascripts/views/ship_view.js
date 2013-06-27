app.Views.ShipView = Backbone.View.extend({
  initialize: function(){
    //jquery UI
    this.$el.draggable({
      snap: ".placement-cell",
      snapMode: "inner",
      snapTolerance: 25
    });

    this.$el.data('model', this.model);
  },
  events:{
    'drag':'detach',
    'click':'reorient'
  },
  detach: function(){
    if (!this.model.cells.at(0)) return;
    var head = this.model.cells.at(0);
    head.detach();
    return head;
    // this.model.cells.each(function(cell){
    //   cell.set('ship', null);
    // });
  },
  reorient: function(e){
    var headCell = this.detach(); //to get headCell
    this.model.toggleOrientation();//set('orientation', 'bottom');
    headCell.attach(this.model, 
      this.model.get('length'), 
      this.model.get('orientation')); //change to options??
    //i need to call dropped after the detach,
    //come to thing of it, perhaps atttached and detach should be model
    //--if we do this.. then we can access attach detach on models instead
    //detach attribute, value
// this is even easier since each cell has a reference to all ship cells
// i couldn't do this prior because of this..
// this thing is now i need to know about a length..AND orientation

    //this.$el.trigger(e);//manually trigger drag, this isn't working
    //1. simulate it
    //2. link the views, but its wierd.. now this view has
    // to know about the other... or we can encapsulate it somehow
    //3. 
  }
});