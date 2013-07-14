app.Views.AttackBoardView = Backbone.View.extend({
  el: '#attack-board',
  initialize: function(){
    this.listenTo(this.collection, 'sync', this.render);
  },
  events:{
    'click .cell:not(.inactive)': function(e, obj) {
      var position = $(e.target).data('position');
      this.attack(position);
    }
  },
  attack: function(position) {
    var self = this;
    this.collection.create({position: position});
  },
  playerTurns: function() {
    return this.collection.where({attacked:true});
  },
  presenter: function() {
    var cells = _.inject(this.playerTurns(), function(memo, obj) {
      memo[obj.get('position')] = {status:obj.get('status'), active: 'inactive'};
      return memo;
    },[]);
    if (!cells[99]) cells[99] = null;
    return {cells: cells}
  },
  render: function() {
    var presenter = this.presenter();
    var html = HoganTemplates['cells'].render(presenter);
    this.$el.html(html);

    this.$el.find('.cell').each(function(index, el) {
      $(el).data('position', index);
    });

    return this;
  }
});

