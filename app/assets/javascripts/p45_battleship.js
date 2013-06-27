app = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function(){
    app.board = new app.Views.PlacementBoardView({
      collection: new app.Collections.CellCollection
    });
    app.gameFormView = new app.Views.GameFormView;
    app.ships = new app.Collections.ShipCollection;
    app.aresenalView = new app.Views.AresenalView({collection: app.ships});
  }
}

$(function(){
  app.initialize()
});