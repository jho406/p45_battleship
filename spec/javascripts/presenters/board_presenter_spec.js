describe('app.Presenters.BoardPresenter', function() {
  var turns = [
    {position: 0, status: 'miss'},
    {position: 2, status: 'hit'}
  ];

  var deployments = [
    {orientation: 'vertical', positions:[1,2]}
  ]

  var board;

  beforeEach(function() {
    board = new app.Presenters.BoardPresenter({boardSize:3});
  });

  describe('#mergeTurns', function() {
    it('should merge turns with cells', function() {
      board.mergeTurns(turns);

      expect(board.cells).toEqual([
        {status:'miss'},
        {},
        {status:'hit'}
      ]);
    });

    it('should take into account duplicate tries with a x(N) string', function() {
      var duplicateTurns = _.clone(turns);
      duplicateTurns.push({position: 0, status: 'miss'});
      board.mergeTurns(duplicateTurns);

      expect(board.cells).toEqual([
        {status:'miss',tries: 'x2'},
        {},
        {status:'hit'}
      ]);
    });
  });

  describe('#mergeDeployments', function() {
    it('should merge turns with deployments', function() {
      board.mergeDeployments(deployments);

      expect(board.cells).toEqual([
        {},
        {orientation: 'vertical', segment: 'head'},
        {orientation: 'vertical', segment: 'tail'}
      ]);
    });
  });

  describe('#presenter', function() {
    it('should merge turns and deployments with cells', function() {
      var presenter = board.presenter(turns, deployments);

      expect(presenter).toEqual(
        {cells:[
          {status: 'miss'},
          {orientation: 'vertical', segment: 'head'},
          {orientation: 'vertical', segment: 'tail', status: 'hit'}
        ]}
      );
    });
  });

  describe('#getSegmentType', function() {
    it('should return "middle" if different indexes', function() {
      expect(board.getSegmentType(1, 2)).toEqual('middle');
    });

    it('should return "head" if the index is 0', function() {
      expect(board.getSegmentType(0, 1000)).toEqual('head');
    });

    it('should return "tail" if indexes are equal and not zero', function() {
      expect(board.getSegmentType(1, 1)).toEqual('tail')
    });

    it('should return "head tail" if indexes are equal and zero', function() {
      expect(board.getSegmentType(0, 0)).toEqual('head tail')
    });
  });
});