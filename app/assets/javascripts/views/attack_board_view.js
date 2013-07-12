app.Views.StatusBoardView = Backbone.View.extend({
  el: '#status-board',
  initialize: function() {
    this.listenTo(this.collection, 'sync', this.render);
  },
  render: function() {
    var presenter = this.presenter();
    var html = HoganTemplates['cells'].render(presenter);
    this.$el.html(html);

    this.$el.find('.cell').each(function(index, el) {
      $(el).data('position', index);
    });

    return this;
  },
  cells: function() {
    return this.collection.where({attacked: false});
  },
  presenter: function() {
    var cells = _.inject(this.cells(), function(memo, obj) {
      memo[obj.get('position')] = obj.get('status');
      return memo;
    },[]);
    if (!cells[99]) cells[99] = null;
    return {cells: cells}
  }
});

app.Views.AttackBoardView = app.Views.StatusBoardView.extend({
  el: '#attack-board',
  events:{
    'click .cell:not(.inactive)': function(e, obj) {
      var position = $(e.target).data('position');
      this.attack(position);
    }
  },
  initialize: function() {
    app.Views.StatusBoardView.prototype.initialize.apply(this, arguments);
  },
  attack: function(position) {
    var self = this;
    this.collection.create({position: position});
  },
  cells: function() {
    return this.collection.where({attacked:true});
  }
});

