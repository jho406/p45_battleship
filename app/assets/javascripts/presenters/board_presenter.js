app.Presenters.BoardPresenter = function(options) {
  this.cells = [];
  this.boardSize = options.boardSize || 100;
  for (var i = this.boardSize -1; i >= 0; i--) {
    this.cells.push({});
  };
}

app.Presenters.BoardPresenter.prototype = {
  presenter: function(turns, deployments) {
    this.mergeDeployments(deployments);
    this.mergeTurns(turns);
    return {cells: this.cells}
  },
  mergeTurns: function(turns) {
    var self = this;
    _.each(turns, function(obj) {
      self.cells[obj.position].status = obj.status;
    });
  },
  mergeDeployments: function(deployments) {
    var self = this;
    _.each(deployments, function(ship, index) {
      _.each(ship.positions, function(position, index, list) {
        self.cells[position].orientation = ship.orientation;
        self.cells[position].segment = self.getSegmentType(index, list.length -1);
      })
    });
  },
  getSegmentType: function(index, lastIndex) {
    var segmentType = 'middle';
    if (index === 0) segmentType = 'head';
    if (index === lastIndex) segmentType = 'tail';
    if (index === 0 && index === lastIndex ) segmentType = 'head tail';
    return segmentType;
  }
}