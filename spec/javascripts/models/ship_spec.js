describe("app.Models.Ship", function() {
  // debugger
  var ship;

  beforeEach(function() {
    ship = new app.Models.Ship;
  });

  describe("#toggleOrientation", function(){
    it("it should toggle the orientation of the ship", function(){
      var previous = ship.get('orientation')
      ship.toggleOrientation();
      expect(ship.get('orientation')).not.toBe(previous);
      ship.toggleOrientation();
      expect(ship.get('orientation')).toBe(previous);
    });
  });

  describe("#positions", function(){
    it("it should return the cells its attached to", function(){
      ship.cells.add([{position:0},{position:1}])
      expect(ship.positions()).toEqual([0,1])
    });
  });
});