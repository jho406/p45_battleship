describe("app.Modedls.Cell", function() {
  // debugger
  var cells, cell;

  beforeEach(function() {
    cells = new app.Collections.CellCollection;
    var iter = 9;
    while(iter--){
      cells.add(new app.Models.Cell);
    };
    cells.meshify(3);
    cell = cells.at(0);
  });

  describe("#andAdjacentCells", function(){
    it("should return itself and all of its nodes in a direction", function(){
      var cs = cells.slice(0, 3);
      expect(cell.andAdjacentCells(3, "right")).toEqual(cs);
    });
  });

  describe("#andEachAdjacentCells", function(){
    it("should call #andAdjacentCells and pass a callback through each item", function(){
      var num = 1, direction = "left", callback = jasmine.createSpy('callback');
      spyOn(cell, 'andAdjacentCells').andReturn([0]);

      cell.andEachAdjacentCells(num, direction, callback);
      expect(cell.andAdjacentCells).toHaveBeenCalledWith(num, direction);
      expect(callback).toHaveBeenCalled();
    });
  });

  describe("#attach", function(){
    it("should set cells and siblings and to the passed object", function(){
      var model = new Backbone.Model;
      model.cells = [];
      cell.attach(model, 3, 'right');
      _.each(cells.slice(0,3), function(c){
        //todo add an attached method??
        expect(c.get('ship')).toEqual(model);
      });
    });

    it("should return false and trigger collision if cell is already occupied, aka a collision", function(){
      var model = new Backbone.Model;
      model.cells = [];
      spyOn(cell, 'trigger');
      cell.attach(model, 3, 'right');
      cell.attach(model, 3, 'right');
      expect(cell.trigger).toHaveBeenCalledWith('collided', cell);
    });
  });

  describe("#detach", function(){
    it("should remove all references to obj from itself and siblings", function(){
      var model = new Backbone.Model;
      model.cells = new Backbone.Collection;
      cell.attach(model, 3, 'right');
      var sibling = cell.siblings.right
      expect(sibling.get('ship')).toEqual(model)
      cell.detach()
      expect(sibling.get('ship')).toEqual(null)
    });
  });

});