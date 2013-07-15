app.Views.PlacementBoardView = Backbone.View.extend({
  el: '#placement-board',
  children: [],
  initialize: function() {
    var self = this;
    this.$el.find('.cell').each(function(index, el) {
      //go through each cell populated by rails and assign a cell
      //model behind it.
      cell = new app.Models.Cell({position: index});

      //assign a view to the element
      self.children.push(
        new app.Views.CellView({el:el, model: cell})
      );
      self.collection.add(cell);
      self.collection.meshify(10);
    });
  }
});
