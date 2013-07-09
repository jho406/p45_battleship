describe("app.Views.AresenalView", function(){
  var ships,
      aresenalView;

  beforeEach(function(){
    ships = new Backbone.Collection();
    aresenalView = new app.Views.AresenalView({collection: ships})
  });

  describe("#presenter", function(){
    it("should return a valid presenter", function(){
      aresenalView.collection.push({name:"test"})
      expect(aresenalView.presenter()).toEqual(
        { ships : [ { name : 'test', shortName : 't' } ] }
      );
    })
  });

  describe("#attachChildViews", function(){
    it("should populate this.children with new ship views",function(){
      ships.push({});
      app.Views.StubView = Backbone.View;
      aresenalView.childView = 'StubView';
      expect(aresenalView.children.length).toBe(0);
      aresenalView.attachChildViews([{}]);
      expect(aresenalView.children.length).toEqual(1);
    });
  });
//todo teardowns
});