app.Models.Cell = Backbone.Model.extend({
  siblings: {},
  defaults: {ship: null},
  //Iterates through each adjacent cell with a callback
  andEachAdjacentCells: function(num, direction, callback) {
    _.each(this.andAdjacentCells(num, direction), callback);
  },
  //All or nothing retrieval of current AND adjacent cells based on a direction
  //and number of cells to retrieve.
  andAdjacentCells: function(num, direction) {
    var foundCells = [this];
    num--;// because its inclusive of this

    while(num--){
      foundCells.push(_.last(foundCells).siblings[direction]);

      if ( _.last(foundCells) == null){
        foundCells = [];
        break;
      };
    }
    return foundCells;
  },
  attach: function(obj, steps, direction) {
    var cells = this.andAdjacentCells(steps, direction);

    //todo: extract method...
    var isCollision = !!_.find(cells, function(cell){
      return !!cell.get("ship");
    });

    if (isCollision){
      this.trigger('collided', this);
      return false;
    }

    _.each(cells, function(cell) {
      obj.cells.push(cell);
      cell.set('ship', obj);
    });

    obj.trigger('attached');
    return this; //head
  },
  detach: function() {
    if (!this.get('ship')) return;
    //todo: refactor so it doesn't need ship...
    //prob pass in a string/ function i bind to.
    var ship = this.get('ship'),
        head = ship.cells.at(0);

    ship.cells.each(function(cell){
      cell.set('ship', null);
    });

    ship.cells.reset();
    ship.trigger('detached');
    return head;
  }
});
