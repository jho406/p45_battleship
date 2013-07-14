describe('extras', function() {
  var env = {}, library;

  var Library = Backbone.Model.extend({
    url:'/',
    paramRoot: 'library'
  });

  // Model attributes.
  var attrs = {
    title  : "The Tempest",
    author : "Bill Shakespeare",
    length : 123
  };

  // Capture ajax settings for comparison.
  Backbone.ajax = function(settings) {
    env.ajaxSettings = settings;
  };

  // Capture old sync settings for comparison.
  Backbone.oldSync = function(method, model, options) {
    env.syncArgs = {
      method: method,
      model: model,
      options: options
    };
  };

  beforeEach(function(){
    library = new Library(attrs);
  })

  describe('toJSON', function() {
    it('should add a paramRoot if model has a paramRoot and options has includeParamRoot', function() {
      var json = library.toJSON({includeParamRoot: true})
      expect(json).toEqual({library: attrs})
    })
  });

  describe('sync', function() {
    it('should add includeParamRoot = true to options on create, update, patch', function() {
      Backbone.sync('create', library, {});
      expect(env.syncArgs.options.includeParamRoot).toBe(true);

      Backbone.sync('update', library, {});
      expect(env.syncArgs.options.includeParamRoot).toBe(true);

      Backbone.sync('patch', library, {});
      expect(env.syncArgs.options.includeParamRoot).toBe(true);
    });
  });

});