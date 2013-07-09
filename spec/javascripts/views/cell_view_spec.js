describe('app.Views.CellView', function(){
  var cellView, model;
  beforeEach(function(){
    model = new Backbone.Model;
    cellView = new app.Views.CellView({ model: model});
  });

  describe("#attachDropped", function(){
    it("should attach an element to the underlying model", function(){
      var item = jasmine.createSpyObj('item', ['get']);
      model.attach = jasmine.createSpy('attach');
      cellView.attachDropped(item);
      expect(model.attach).toHaveBeenCalled();
    });
  });

  describe("#presenter", function(){
    it("should return an empty object if no ship", function(){
      expect(cellView.presenter()).toEqual({});
    });

    it("should return a valid presenter", function(){
      model.set('ship', new Backbone.Model({name: "test"}));
      expect(cellView.presenter()).toEqual({ name : 'test', shortName : 't' });
    });
  });
});