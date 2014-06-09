widgets.directive("widget", ->
  {
    restrict: 'E',
    scope: { lvlObjs:'=' },
    controller: ($scope, $element, $attrs) ->
      $scope.rootObjs = $scope.lvlObjs
      $scope.parents = new Array()
      $scope.parentsNames = new Array()
      $scope.ocorrencia
      
      $scope.enter = (curObj, lvlScope) ->
        $element.find(".loading").addClass "open"
        setTimeout ->
          $element.find('[class^="step-"].current').removeClass("current").addClass("past").next().addClass "current"
          $element.find(".loading").removeClass "open"
        , 500 

        $scope.parents.push $scope.lvlObjs

        if lvlScope is'local'
          $scope.lvlObjs = curObj.locais
          $scope.curParent = curObj.nome
        else if lvlScope is 'secao'
          $scope.parentsNames.push $scope.curParent
          $scope.lvlObjs = curObj.secoes
          $scope.curParent = curObj.nome
        else if lvlScope is 'ocorrencia'
          $scope.parentsNames.push $scope.curParent
          $scope.lvlObjs = curObj.ocorrencias
          $scope.curParent = curObj.num

      $scope.leave = (rtLevelScrope) ->
        $element.find('[class^="step-"].current').removeClass("current").prev().addClass("current").removeClass "past"

        if rtLevelScrope is 'local'
          $scope.lvlObjs = $scope.rootObjs
        else if rtLevelScrope is 'secao'
          $scope.lvlObjs = $scope.parents.pop()
          $scope.curParent = $scope.parentsNames.pop()
        else if rtLevelScrope is 'ocorrencia'
          $scope.lvlObjs = $scope.parents.pop()
          $scope.curParent = $scope.parentsNames.pop()

      $scope.viewIssue = (curObj) ->
        if curObj.titulo
          $scope.ocorrencia = curObj
          $("#visualizarOcorrencia").modal 'show'

      $scope.notDivide = ->
        $element.find(".loading").addClass "open"
        setTimeout ->
          $element.find(".loading").removeClass "open"
        , 500

        $scope.pastObjs = $scope.lvlObjs
        $scope.lvlObjs = new Array()
        angular.forEach $scope.pastObjs, (obj) ->

          angular.forEach obj.ocorrencias, (ocr) ->
            ocr.altTitulo = "#{ ocr.titulo } - Seção #{ obj.num }"
            ocr.parentName = obj.num
            $scope.lvlObjs.push ocr

        $scope.curLvl = 'Ocorrências'
        $scope.divided = true

      $scope.divide = ->
        $element.find(".loading").addClass "open"
        setTimeout ->
          $element.find(".loading").removeClass "open"
        , 500

        $scope.lvlObjs = $scope.pastObjs
        $scope.curLvl = 'Seções'
        $scope.divided = false
  }
)
.directive 'statLabel', ->
  {
    restrict: 'C',
    link: (scope, element, attrs) ->
      scope.statLabel = if (scope.ocorrencia and scope.ocorrencia.parada) or (scope.secao and scope.secao.parada) or (scope.local and scope.local.parada) or (scope.mun and scope.mun.parada) 'parada' then 'falta mesário'
  }