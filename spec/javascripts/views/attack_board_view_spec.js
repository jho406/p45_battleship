describe("app.Views.StatusBoardView", function(){
  var statusBoardView, collection;

  beforeEach(function(){
    collection = new Backbone.Collection;
    statusBoardView = new app.Views.StatusBoardView({collection: collection});
  });

  describe("#cells", function(){
    it("should return cells where the opponent attacked", function(){
      collection.add([{attacked: true}, {attacked: false}]);
      var filtered = statusBoardView.cells();
      expect(filtered.length).toEqual(1);
      expect(filtered[0].get('attacked')).toEqual(false);
    });
  });

  describe("#presenter", function(){
    it("should return a valid presenter", function(){
      collection.add([{attacked: true}, {attacked: false}]);
      var presented = statusBoardView.presenter();
      expect(presented.cells.length).toEqual(100);
    });
  });
});

describe("app.Views.AttackBoardView", function(){
  var statusBoardView, collection;

  beforeEach(function(){
    collection = new Backbone.Collection;
    statusBoardView = new app.Views.AttackBoardView({collection: collection});
  });

  describe("#cells", function(){
    it("should return cells where the opponent attacked", function(){
      collection.add([{attacked: true}, {attacked: false}]);
      var filtered = statusBoardView.cells();
      expect(filtered.length).toEqual(1);
      expect(filtered[0].get('attacked')).toEqual(true);
    });
  });

  describe("#attack", function(){
    it("should create a new turn with the clicked cell", function(){
      spyOn(collection, 'create')
      statusBoardView.attack(0);
      expect(collection.create).toHaveBeenCalledWith({position:0});
    });
  });
})