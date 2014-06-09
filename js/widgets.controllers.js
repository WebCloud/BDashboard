widgets.controller( 'OcorrenciaCtrl', function OcorrenciaCtrl( $scope, $location, ocorrenciasStorage, filterFilter ) {
  var ocorrencias = $scope.ocorrencias = ocorrenciasStorage.get();
  $scope.lvlObjs = ocorrencias;

  $scope.$watch('ocorrencias', function() {
    //alterações na listagem, como contadores, devem ser feitas aqui
    ocorrenciasStorage.put(ocorrencias);
  }, true);

  if ( $location.path() === '' ) $location.path('/');
  $scope.location = $location;

  $scope.$watch( 'location.path()', function( path ) {
    $location.path('/');
  });

});
