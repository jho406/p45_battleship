describe("app.Collections.CellCollection", function() {
  // debugger
  var cells;

  beforeEach(function() {
    cells = new app.Collections.CellCollection;
  });

  describe("meshify", function(){
    it("should create a mesh of linkedlist of x by x length", function(){
      var model = app.Models.Cell
      var c = [new model, new model, new model, new model];

      cells.add(c);
      cells.meshify(2);

      expect(cells.at(0).siblings.top).toEqual(null);
      expect(cells.at(0).siblings.right).toEqual(c[1]);
      expect(cells.at(0).siblings.bottom).toEqual(c[2]);
      expect(cells.at(0).siblings.left).toEqual(null);

      expect(cells.at(3).siblings.top).toEqual(c[1]);
      expect(cells.at(3).siblings.right).toEqual(null);
      expect(cells.at(3).siblings.bottom).toEqual(null);
      expect(cells.at(3).siblings.left).toEqual(c[2]);
    });
  });

  describe("add", function(){
    xit("what is this for???")
  });
});