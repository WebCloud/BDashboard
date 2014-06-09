widgets.factory( 'ocorrenciasStorage', function() {
  //var STORAGE_ID = 'widgets.ocorrencias';
  var STORAGE_ID = 'widgets.localidades';

  return {
    get: function() {
      return JSON.parse(localStorage.getItem(STORAGE_ID) || '[]');
    },

    put: function( ocorrencias ) {
      localStorage.setItem(STORAGE_ID, JSON.stringify(ocorrencias));
    }
  };
});
