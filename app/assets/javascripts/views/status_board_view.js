app.Views.StatusBoardView = Backbone.View.extend({
  el: '#status-board',
  cellCount: 100,
  initialize: function(attrs) {
    this.turns = attrs.turns
    this.deployments = attrs.deployments
    this.listenTo(this.turns, 'sync', this.render);

    this.deployments = attrs.deployments;
  },
  render: function() {
    var presenter = this.presenter();
    var html = HoganTemplates['cells'].render(presenter);
    this.$el.html(html);
    return this;
  },
  opponentTurns: function() {
    return this.turns.where({attacked: false});
  },
  presenter: function() {
    var turns = _.map(this.opponentTurns(), function(turn) {
      return turn.attributes;
    });

    var deployments = this.deployments.map(function(deployment){
      return deployment.attributes;
    });

    var board = new app.Presenters.BoardPresenter(this.cellCount);
    return board.presenter(turns, deployments);
  }
});