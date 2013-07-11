describe('app.Views.ShipView', function(){
  var model, collection, shipView;

  beforeEach(function(){
    spyOn(app.Views.ShipView.prototype, 'render');
    model = new Backbone.Model();
    collection = new Backbone.Collection([model]);
    shipView = new app.Views.ShipView({model: model});
    model.cells = collection;
  });

  describe('#detach', function(){
    it('should detach ship from the underlying model and its siblings', function(){
      model.detach = jasmine.createSpy('detach');
      shipView.detach();
      expect(model.detach).toHaveBeenCalled();
    });
  });

  describe('#reorient', function(){
    it('should detach the ship and reattach with a new orientation', function(){
      model.detach = jasmine.createSpy('detach');
      model.toggleDirection = jasmine.createSpy('toggleDirection');
      model.attach = jasmine.createSpy('attach')

      shipView.reorient();

      expect(model.detach).toHaveBeenCalled();
      expect(model.toggleDirection).toHaveBeenCalled();
      expect(model.attach).toHaveBeenCalled();
    });
  });
});