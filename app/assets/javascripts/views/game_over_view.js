app.Views.GameOver = Backbone.View.extend({
  el: '#game-over',
  initialize: function() {
    this.listenTo(this.model, 'over', this.render);
  },
  presenter: function() {
    var defaultPresenter = this.model.toJSON();
    if (defaultPresenter.won){
      defaultPresenter.status = "You Win!";
    } else {
      defaultPresenter.status = "You Lose";
    }
    return defaultPresenter;
  },
  render: function() {
    this.$el.html(HoganTemplates['over'].render(this.presenter()));
    this.$el.show().find('div').addClass("animateIn");
    return this;
  }
});