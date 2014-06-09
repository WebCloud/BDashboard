widgets.directive("widget", function(){
  return {
    restrict: 'E',
    scope: { lvlObjs:'=' },
    controller: function($scope, $element, $attrs){
      $scope.rootObjs = $scope.lvlObjs;
      $scope.parents = new Array();
      $scope.parentsNames = new Array();
      $scope.ocorrencia;
      
      $scope.enter = function(curObj, lvlScope){
        $element.find(".loading").addClass("open");
        setTimeout(function() {
          $element.find('[class^="step-"].current').removeClass("current").addClass("past").next().addClass("current");
          $element.find(".loading").removeClass("open");
        }, 500);

        $scope.parents.push($scope.lvlObjs);

        if(lvlScope==='local'){
          $scope.lvlObjs = curObj.locais;
          $scope.curParent = curObj.nome;
        } else if (lvlScope==='secao'){
          $scope.parentsNames.push($scope.curParent);
          $scope.lvlObjs = curObj.secoes;
          $scope.curParent = curObj.nome;
        } else if (lvlScope==='ocorrencia'){
          $scope.parentsNames.push($scope.curParent);
          $scope.lvlObjs = curObj.ocorrencias;
          $scope.curParent = curObj.num;
        }
      };

      $scope.leave = function(rtLevelScrope){
        $element.find('[class^="step-"].current').removeClass("current").prev().addClass("current").removeClass("past");

        if(rtLevelScrope==='local'){
          $scope.lvlObjs = $scope.rootObjs;
        } else if(rtLevelScrope==='secao'){
          $scope.lvlObjs = $scope.parents.pop();
          $scope.curParent = $scope.parentsNames.pop();
        } else if (rtLevelScrope==='ocorrencia'){
          $scope.lvlObjs = $scope.parents.pop();
          $scope.curParent = $scope.parentsNames.pop();
        }
      };

      $scope.viewIssue = function (curObj) {
        if(curObj.titulo){
          $scope.ocorrencia = curObj;
          $("#visualizarOcorrencia").modal('show');
        }
      }

      $scope.notDivide = function () {
        $element.find(".loading").addClass("open");
        setTimeout(function() {
          $element.find(".loading").removeClass("open");
        }, 500);

        $scope.pastObjs = $scope.lvlObjs;
        $scope.lvlObjs = new Array();
        angular.forEach($scope.pastObjs,function(obj){
          angular.forEach(obj.ocorrencias,function(ocr){
            ocr.altTitulo = ocr.titulo+' - Seção '+obj.num;
            ocr.parentName = obj.num;
            $scope.lvlObjs.push(ocr);
          });
        });
        $scope.curLvl = 'Ocorrências';
        $scope.divided = true;
      };

      $scope.divide = function () {
        $element.find(".loading").addClass("open");
        setTimeout(function() {
          $element.find(".loading").removeClass("open");
        }, 500);

        $scope.lvlObjs = $scope.pastObjs
        $scope.curLvl = 'Seções';
        $scope.divided = false;
      };
    }
  }
})
.directive('statLabel', function(){
  return {
    restrict: 'C',
    link: function(scope, element, attrs){
      scope.statLabel = (
          (scope.ocorrencia && scope.ocorrencia.parada) ||
          (scope.secao && scope.secao.parada) ||
          (scope.local && scope.local.parada) ||
          (scope.mun && scope.mun.parada)
        ) ? 'parada' : 'falta mesário';
    }
  };
});