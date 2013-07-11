describe("app.Models.Ship", function() {
  // debugger
  var ship;

  beforeEach(function() {
    ship = new app.Models.Ship;
  });

  describe("#toggleDirection", function(){
    it("it should toggle the direction of the ship", function(){
      var previous = ship.get('direction')
      ship.toggleDirection();
      expect(ship.get('direction')).not.toBe(previous);
      ship.toggleDirection();
      expect(ship.get('direction')).toBe(previous);
    });
  });

  describe("#positions", function(){
    it("it should return the cells its attached to", function(){
      ship.cells.add([{position:0},{position:1}])
      expect(ship.positions()).toEqual([0,1])
    });
  });
});