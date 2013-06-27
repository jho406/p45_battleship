app.Views.AresenalView = Backbone.View.extend({
  el: '#aresenal',
  initialize: function(){
    this.listenTo(this.collection, 'reset', this.render);
  },
  children:[],
  render:function(){
    this.$el.html(
      HoganTemplates['aresenal'].render({ships:this.collection.toJSON()})
    );
    var self = this;
    this.$el.find('.ship').each(function(index, obj){
      var shipView = new app.Views.ShipView({el:obj, model: self.collection.at(index)});
      self.children.push(shipView);
    });
  }
});
