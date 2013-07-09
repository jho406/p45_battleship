!function(Backbone){
  var sync = Backbone.sync;
  Backbone.sync = function( method, model, options ) {

    if (options.data == null && model && (method === 'create' || method === 'update' || method === 'patch')) {
      options.includeParamRoot = true;
    }

    return sync.apply(this, [method, model, options]);
  };

  _.extend(Backbone.Model.prototype, {
    toJSON: function(options) {
      var data = {},
          attrs = _.clone(this.attributes);

      if(options && options.includeParamRoot && this.paramRoot) {
        data[this.paramRoot] = attrs;
      } else {
        data = attrs;
      }

      return data;
    }
  });

}(Backbone);