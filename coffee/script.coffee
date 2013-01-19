###
Criação da função e parâmetros para a fixação da subnav.
###
$win = $ window
$nav = $ '.subnav'
navTop = $('.subnav').length and $('.subnav').offset().top - 40
isFixed = 0

processScroll = ->
  i = 0
  scrollTop = $win.scrollTop()
  if scrollTop >= navTop and not isFixed
    isFixed = 1
    $nav.addClass 'subnav-fixed'
  else if scrollTop <= navTop and isFixed
    isFixed = 0
    $nav.removeClass 'subnav-fixed'
    
processScroll()

$win.on 'scroll', processScroll


###
Adição da funcionalidade of expandir para as widgets.
Quando o botão of expandir for clicado irá ser adicionada a classe expanded para a widget.
###    
$(".expander").on "click", (e) ->
  $(@).parents('[class^="widget-"]').toggleClass "expanded"
  e.preventDefault()
  

###
Adição da funcionalidade of painel of configuração para as widgets.
quando o botão of configurações for clicado irá ser adicionada a classe open para o painel of configurações,
abrindo o mesmo.
### 
$(".settings-nub").on "click", (e) ->
  $(@).toggleClass("open").parent().parent().find(".settings").toggleClass "open"
  e.preventDefault()


###
Botando o botão do formulário of configurações para fechar o painel quando o mesmo for clicado.
### 
$(".settings button").on "click",(e) ->
  if $(@).hasClass "btn-filtro"
    $(@).parent().parent().parent().find(".settings-nub, .settings").toggleClass "open"
  e.preventDefault()


###
Adição do filtro para indicar as tooltips, todo elemento com o atributo rel='tooltip' irá ter um tooltip,
com o conteúdo igual ao do atributo title deste mesmo elemento.
Esse código usa o bootstrap.tooltip que está incluso no bootstrap.min.js
### 
$("[rel='tooltip']").tooltip()


###
Adição da funcionalidade of altocomplete para os elementos com a classe chosen.
Este auto complete NÃO contém chamadas em AJAX, ele pega e monta a lista of elementos baseada em um ul ou select.
Esse código usa o chosen que está incluso no chosen.jquery.min.js
### 
$(".chosen").chosen {no_results_text: "No result found"}


###
definição of um atributo para simular o retorno of uma consulta a uma página em ajax para os autocomplete.
### 
data = {items: [
  {value: "21", name: "A item"},
  {value: "43", name: "Another item"},
  {value: "46", name: "Some other fake item"},
  {value: "54", name: "Yet another fake item"}
  ]}


###
Adição da funcionalidade of autocomplete, com multiplos itens, para os elementos com a classe autocomplete e para o input of #message-form.
Este ultimo foi necessária outra configuração pois o label inicial para o elemento é diferente do padrão.
Esse código usa o AutoSuggest que está incluso no jquery.autosugest.min.js
### 
$(".autocomplete").autoSuggest data.items, {selectedItemProp: "name", searchObjProps: "name", startText: "Add filter", emptyText: "No results", limitText: "You can't make another selection", minChars: 2, selectionLimit: 3}
$("#message-form input").autoSuggest data.items, {selectedItemProp: "name", searchObjProps: "name", startText: "Send to", emptyText: "No results", limitText: "You can't make another selection", minChars: 2, selectionLimit: 3}


###
Adição do efeito of focus/blur para o elemento do autocomplete igual ao comportamento dos inputs padrão.
###
$(".as-selections input").focus(->
    $(@).parent().parent().addClass "focus"
  ).blur ->
    $(@).parent().parent().removeClass "focus"


###
Adição da funcionalidade of autocomplete, com apenas 1 item, para os elementos com a classe mun-autocomplete.
Esse código usa o bootstrap.typeahead que está incluso no bootstrap.min.js
###
$(".mun-autocomplete").typeahead {
    source: [
        'A place',
        'Another place',
        'Some other place'
    ]
  }


###
Adição da funcionalidade of filtro online/offile para a widget of transmissão.
Quando o botão online/offline for clicado, irá ser adicionada a classe active para este botão e serão escondidos
os elementos com o data-trans-status que não for compatível com o data-trans-status do botão.
###
$('[class^="widget-"] > .form-actions > .btn').on "click", (e) ->
  if $(@).data("toggle") is "button"
    $(@).removeClass "transparent"
    $(@).next().toggleClass "transparent"
    $(@).prev().toggleClass "transparent"
    if $(@).next(".btn").hasClass "active"
      $(@).next(".btn").button "toggle"
    if $(@).prev(".btn").hasClass "active"
      $(@).prev(".btn").button "toggle"
      
  $button = $(@)

  $(@).parent().next().children().children("li").each -> 
    if $(@).data("trans-status") is $button.data "trans-status"
      $(@).show()
    else if ($(@).data("trans-status") isnt $button.data "trans-status") and ( $button.hasClass "active" )
      $(@).show()
    else
      $(@).hide()
  e.preventDefault()


###
Abre as opções (próximo nível, visualizar pessoas e adicionar x) dos itens das listas que estão presentes nas widgets of transmissão, ocorrências e totalização.
###
$(".code-wrap .has-item-options li > a").live "click", (e) ->
  $(@).next(".item-options").slideToggle "fast"
  $(@).parent("li").has(".item-options").toggleClass "active"
  e.preventDefault()


###
Delega aos botões presente nas opções dos itens das listas das widgets para fechar o mini-painel deles quando clicados.
###
$(".option-open, .option-close").live "click", (e) ->
  $(@).parent().slideUp "fast"
  $(@).parent().parent("li").toggleClass "active"
  e.preventDefault()


###
Adiciona a funcionalidade of navegação em 'páginas' para as widgets of ocorrências, totalização e ocorrências da corregedoria.
Esta funcionalidade simula com o setTimeout o carregamento do próximo nível com AJAX. O código inicial da próxima página já estará
presente no html, como #step-x, sendo 'x' o número da página que o próximo nível estará. Cada widget terá um nível máximo of páginas,
e todas já deverão conter o html das páginas (#step-x) presentes no início para os efeitos poderem ser processados.
ex.:

<div class='content-wrap'>
  <div class='step-1 current'>
    <!-- div atualmente visível na tela -->
  </div>
  <div class='step-2'>
   <!-- div escondida, e aqui irá o conteúdo que será carregado via AJAX -->
  </div>
  <div class='step-3'>
    <!-- div escondida, e aqui irá o conteúdo que será carregado via AJAX -->
  </div>
  ...
</div>

Com um método com AJAX funcionando of verdade, após a chamada $(this).parents('[class^="widget-"]').find(".loading").addClass("open"),
no success do método AJAX injetaria-se o HTML of resposta na div $('.step-x').next('.step-x+1').html($meuHTMLdeResposta).
Em seguida seriam execudados os procedimentos que estão contidos no setTimeout para promover a animação e esconder o painel
com indicador of carregamento.

A formatação do HTML deve ser idêntica à encontrada dentro das divs .step-x nas widgets.
###
$(".btn-next").live "click", (e) ->
  $(@).parents('[class^="widget-"]').find(".loading").addClass "open"
  setTimeout =>
    $(@).parents('[class^="step-"]').removeClass("current").addClass("past").next().addClass "current"
    $(@).parents('[class^="widget-"]').find(".loading").removeClass "open"
    $(@).removeClass "current-clicked"
  , 500
  e.preventDefault()


###
Adiciona a navegação of volta entre as 'páginas' das widgets of ocorrências, totalização e ocorrências da corregedoria.
Para voltar para a 'página' anterior não será necessário ajax, pois a 'página' anterior irá estar apenas 'escondida' à esquerda
da página atual. A página atual será marcada com a classe current e as páginas anteriores com a classe past.
As 'próximas' páginas não precisam ter outras classes a não ser a classe step-x.
ex.:

<div class='content-wrap'>
  <div class='step-1 past'>
    <!-- div escondida, que já tem o conteúdo HTML carregado e cacheado -->
  </div>
  <div class='step-2 past'>
    <!-- div escondida, que já tem o conteúdo HTML carregado e cacheado -->
  </div>
  <div class='step-3 current'>
    <!-- div atualmente visível na tela -->
  </div>
  <div class='step-4'>
    <!-- div escondida, e aqui irá o conteúdo que será carregado via AJAX -->
  </div>
  ...
</div>
###
$(".btn-prev").live "click", (e) ->
  $(@).parent().removeClass("current").prev().addClass("current").removeClass "past"
  e.preventDefault()


###
Para as widgets of ocorrências e of totalização, deverá ter a opção of dividir ou não as ultimas 'páginas',
para os usuários que estão em zonas com poucas seções e locais, respectivamente.
Este método simula a injeção of conteúdo HTML ($htmlOcorrencia, $htmlSecao, $$htmlLocal e $htmlSecaoTot) vindo of uma requisição AJAX.
Esta função é re-utilizada pelos dois botões of dividir/não dividir das widgets of totalização e ocorrências.
###
$(".btn-divide").live "click", (e) ->
  $htmlOcorrencia = '<a href="#" class="btn btn-small pull-left btn-prev clearfix" rel="tooltip" title="Back"><i class="icon-circle-arrow-left"></i></a>
                  <a href="#" class="btn btn-small pull-right btn-divide clearfix" data-type="ocorrencia" style="display:none" rel="tooltip" title="toggle view mode"><i class="icon-reorder"></i></a>
                  <a href="#" class="btn btn-small pull-right btn-divide clearfix not-divided" data-type="ocorrencia" style="display:inline" rel="tooltip" title="toggle view mode"><i class="icon-columns"></i></a>
                  <h3>
                    The visualization has changed!
                    <span class="current-place-label">Item Whatever The Hell they want to name this freaking school D</span>
                  </h3>
                  <ul class="nav nav-pills nav-stacked hover-inverse">
                    <li>
                      <a href="#visualizarOcorrencia" data-toggle="modal">
                        <span class="label label-icon" rel="tooltip" title="a label"><i class="icon-check-empty"></i></span>
                        <span class="link-text">Item A</span>
                        <span class="badge pull-right">23ª</span>
                      </a>
                    </li>
                    <li class="falta-mesario">
                      <a href="#visualizarOcorrencia" data-toggle="modal">
                        <span class="label label-icon" rel="tooltip" title="another label"><i class="icon-check"></i></span>
                        <span class="link-text"><del>Item B</del></span>
                        <span class="badge pull-right">24ª</span>
                        <span class="label pull-right">a label</span>
                      </a>
                    </li>
                    <li>
                      <a href="#visualizarOcorrencia" data-toggle="modal">
                        <span class="label label-icon" rel="tooltip" title="another label"><i class="icon-check"></i></span>
                        <span class="link-text"><del>Item C</del></span>
                        <span class="badge pull-right">21ª</span>
                      </a>
                    </li>
                    <li class="parada">
                      <a href="#visualizarOcorrencia" data-toggle="modal">
                        <span class="label label-icon" rel="tooltip" title="a label"><i class="icon-check-empty"></i></span>
                        <span class="link-text">Item D</span>
                        <span class="badge pull-right">21ª</span>
                        <span class="label pull-right">another label</span>
                      </a>
                    </li>
                    <li>
                      <a href="#visualizarOcorrencia" data-toggle="modal">
                        <span class="label label-icon" rel="tooltip" title="a label"><i class="icon-check-empty"></i></span>
                        <span class="link-text">Item E</span>
                        <span class="badge pull-right">23ª</span>
                      </a>
                    </li>
                  </ul>
                  <a href="#" class="btn btn-large btn-load-more">Load more</a>

                  <script type="text/javascript">
                    $("[rel=\'tooltip\']").tooltip();
                  </script>'

  $htmlSecao = '<a href="#" class="btn btn-small pull-left btn-prev clearfix" rel="tooltip" title="Back"><i class="icon-circle-arrow-left"></i></a>
                  <a href="#" class="btn btn-small pull-right btn-divide clearfix" rel="tooltip" data-type="ocorrencia" title="toggle view mode"><i class="icon-reorder"></i></a>
                  <a href="#" class="btn btn-small pull-right btn-divide clearfix not-divided" data-type="ocorrencia" rel="tooltip" title="toggle view mode"><i class="icon-columns"></i></a>
                  <h3>
                    Yay! Changed the view mode
                    <span class="current-place-label">Item Whatever The Hell they want to name this freaking school D</span>
                  </h3>
                  <ul class="nav nav-pills nav-stacked has-item-options hover-inverse">
                    <li>
                      <a href="#">
                        <span class="link-text">Item A</span>
                        <span class="badge pull-right">13</span>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#cadastrarOcorrencia" data-toggle="modal" class="btn btn-large pull-left" rel="tooltip" title="Add something here"><i class="icon-plus"></i></a>
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="secao" class="btn btn-large user-list" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                        <a href="#" class="btn btn-large pull-right btn-next" rel="tooltip" title="Enter this level"><i class="icon-circle-arrow-right"></i></a>
                      </div>
                    </li>
                    <li class="falta-mesario">
                      <a href="#">
                        <span class="link-text">Item B</span>
                        <span class="badge pull-right">21</span>
                        <span class="label pull-right">a label</span>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#cadastrarOcorrencia" data-toggle="modal" class="btn btn-large pull-left" rel="tooltip" title="Add something here"><i class="icon-plus"></i></a>
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="secao" class="btn btn-large user-list" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                        <a href="#" class="btn btn-large pull-right btn-next" rel="tooltip" title="Enter this level"><i class="icon-circle-arrow-right"></i></a>
                      </div>
                    </li>
                    <li>
                      <a href="#">
                        <span class="link-text">Item C</span>
                        <span class="badge pull-right">31</span>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#cadastrarOcorrencia" data-toggle="modal" class="btn btn-large pull-left" rel="tooltip" title="Add something here"><i class="icon-plus"></i></a>
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="secao" class="btn btn-large user-list" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                        <a href="#" class="btn btn-large pull-right btn-next" rel="tooltip" title="Enter this level"><i class="icon-circle-arrow-right"></i></a>
                      </div>
                    </li>
                    <li class="parada">
                      <a href="#">
                        <span class="link-text">Item D</span>
                        <span class="badge pull-right">18</span>
                        <span class="label pull-right">another label</span>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#cadastrarOcorrencia" data-toggle="modal" class="btn btn-large pull-left" rel="tooltip" title="Add something here"><i class="icon-plus"></i></a>
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="secao" class="btn btn-large user-list" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                        <a href="#" class="btn btn-large pull-right btn-next" rel="tooltip" title="Enter this level"><i class="icon-circle-arrow-right"></i></a>
                      </div>
                    </li>
                    <li>
                      <a href="#">
                        <span class="link-text">Item E</span>
                        <span class="badge pull-right">1</span>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#cadastrarOcorrencia" data-toggle="modal" class="btn btn-large pull-left" rel="tooltip" title="Add something here"><i class="icon-plus"></i></a>
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="secao" class="btn btn-large user-list" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                        <a href="#" class="btn btn-large pull-right btn-next" rel="tooltip" title="Enter this level"><i class="icon-circle-arrow-right"></i></a>
                      </div>
                    </li>
                  </ul>

                  <script type="text/javascript">
                    $("[rel=\'tooltip\']").tooltip();
                  </script>'

  $htmlLocal = '<a href="#" class="btn btn-small pull-left btn-prev clearfix" rel="tooltip" title="Back"><i class="icon-circle-arrow-left"></i></a>
                  <a href="#" class="btn btn-small pull-right btn-divide clearfix" rel="tooltip" data-type="totalizacao" title="toggle view mode"><i class="icon-reorder"></i></a>
                  <a href="#" class="btn btn-small pull-right btn-divide clearfix not-divided" rel="tooltip" data-type="totalizacao" title="toggle view mode"><i class="icon-columns"></i></a>
                  <h3>
                    The view mode changed, hooray!
                    <span class="current-place-label">Item A</span>
                  </h3>
                  <ul class="nav nav-pills nav-stacked has-item-options hover-inverse">
                    <li>
                      <a href="#">
                        <span class="link-text">Item A</span>
                        <div class="progress progress-info pull-right">
                          <div class="bar" style="width: 60%;">
                            <span>120 of 220</span>
                          </div>
                        </div>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="local" class="btn btn-large pull-left" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                        <a href="#" class="btn btn-large pull-right btn-next" rel="tooltip" title="Enter this level"><i class="icon-circle-arrow-right"></i></a>
                      </div>
                    </li>
                    <li>
                      <a href="#">
                        <span class="link-text">Item B</span>
                        <div class="progress progress-success pull-right">
                          <div class="bar" style="width: 80%;">
                            <span>200 of 220</span>
                          </div>
                        </div>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="local" class="btn btn-large pull-left" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                        <a href="#" class="btn btn-large pull-right btn-next" rel="tooltip" title="Enter this level"><i class="icon-circle-arrow-right"></i></a>
                      </div>
                    </li>
                    <li>
                      <a href="#">
                        <span class="link-text">Item C</span>
                        <div class="progress progress-info pull-right">
                          <div class="bar" style="width: 60%;">
                            <span>120 of 220</span>
                          </div>
                        </div>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="local" class="btn btn-large pull-left" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                        <a href="#" class="btn btn-large pull-right btn-next" rel="tooltip" title="Enter this level"><i class="icon-circle-arrow-right"></i></a>
                      </div>
                    </li>
                    <li>
                      <a href="#" rel="tooltip" title="Item Whatever The Hell they want to name this freaking school D">
                        <span class="link-text">Item Whatever The Hell they want to name this freaking school D</span>
                        <div class="progress progress-warning pull-right">
                          <div class="bar" style="width: 30%;">
                            <span>80 of 220</span>
                          </div>
                        </div>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="local" class="btn btn-large pull-left" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                        <a href="#" class="btn btn-large pull-right btn-next" rel="tooltip" title="Enter this level"><i class="icon-circle-arrow-right"></i></a>
                      </div>
                    </li>
                    <li>
                      <a href="#">
                        <span class="link-text">Item E</span>
                        <div class="progress progress-danger pull-right">
                          <div class="bar" style="width: 10%;">
                            <span>22 of 220</span>
                          </div>
                        </div>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="local" class="btn btn-large pull-left" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                        <a href="#" class="btn btn-large pull-right btn-next" rel="tooltip" title="Enter this level"><i class="icon-circle-arrow-right"></i></a>
                      </div>
                    </li>
                  </ul>'

  $htmlSecaoTot = '<a href="#" class="btn btn-small pull-left btn-prev clearfix" rel="tooltip" title="Back"><i class="icon-circle-arrow-left"></i></a>
                  <a href="#" class="btn btn-small pull-right btn-divide clearfix" rel="tooltip" style="display:none" data-type="totalizacao" title="toggle view mode"><i class="icon-reorder"></i></a>
                  <a href="#" class="btn btn-small pull-right btn-divide clearfix not-divided" rel="tooltip" style="display:inline" data-type="totalizacao" title="toggle view mode"><i class="icon-columns"></i></a>
                  <h3>
                    <span class="current-place-label">You just changed the view mode!</span>
                  </h3>
                  <div class="progress progress-success">
                    <div class="bar" style="width: 88%;">
                      <span>210 of 220</span>
                    </div>
                  </div>
                  <ul class="nav nav-pills nav-stacked has-item-options hover-inverse">
                    <li>
                      <a href="#">
                        <span class="link-text">Item A - Local B</span>
                        <span class="label pull-right">some label</span>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="secao" class="btn btn-large pull-left" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                      </div>
                    </li>
                    <li>
                      <a href="#">
                        <span class="link-text">Item B - Local A</span>
                        <span class="label pull-right">other label</span>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="secao" class="btn btn-large pull-left" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                      </div>
                    </li>
                    <li>
                      <a href="#">
                        <span class="link-text">Item C - Local B</span>
                        <span class="label pull-right">another label</span>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="secao" class="btn btn-large pull-left" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                      </div>
                    </li>
                    <li>
                      <a href="#">
                        <span class="link-text">Item D - Local B</span>
                        <span class="label pull-right">another label</span>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="secao" class="btn btn-large pull-left" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                      </div>
                    </li>
                    <li>
                      <a href="#">
                        <span class="link-text">Item E - Local C</span>
                        <span class="label pull-right">other label</span>
                      </a>
                      <div class="item-options clearfix">
                        <a href="#visualizarPessoas" data-toggle="modal" data-type="secao" class="btn btn-large pull-left" rel="tooltip" title="View some data from this item"><i class="icon-user"></i></a>
                      </div>
                    </li>
                  </ul>'

  $(@).parent().parent().parent().find(".loading").addClass "open"
  if $(@).hasClass "not-divided"
    $(@).hide().prev().show()
    setTimeout =>
      $(@).parent().parent().parent().find(".loading").removeClass "open"
      if $(@).data("type") is "ocorrencia"
        $(@).parent().html $htmlSecao
      else if $(@).data("type") is "totalizacao"
        $(@).parent().html $htmlLocal
    , 500
  else
    $(@).hide().next().show()
    setTimeout =>
      $(@).parent().parent().parent().find(".loading").removeClass "open"
      if $(@).data("type") is "ocorrencia"
        $(@).parent().html $htmlOcorrencia
      else if $(@).data("type") is "totalizacao"
        $(@).parent().html $htmlSecaoTot
    , 500
  $(@).tooltip "hide"
  e.preventDefault()


###
Quando o usuário clicar no checkbox para marcar uma ocorrência como fechada ele terá o feedback no botão do formulário,
onde o mesmo irá mudar of Enviar para Fechar ocorrência. O inverso irá acontecer quando o usuário desmarcar o checkbox.
###
$(".modal .operations .resolved").live "click", ->
  if $(@).attr "checked"
    $(@).parent().next().next().html "Change the status"
    $(@).parent().next().after '
    <select class="input-small inline" id="solucao" style="margin: 0 25px 0 0;">
      <option value="">Select one</option>
      <option value="reiniciar_UE">another status</option>
      <option value="trocar_cartao_de_memoria">never mind</option>
      <option value="troca_de_urna" data-solution="troca">other good status</option>
    </select>'
  else
    $(@).parent().next().next().next().html "Save"
    $(@).parent().next().next("#solucao").remove()
    
$(".modal .operations .duplicated").live "click", ->
  if $(@).attr "checked"
    $(@).parent().next().html "A different action"
  else
    $(@).parent().next().html "Save"


###
Quando o usuário clicar no botão para bloquear um informante ele terá um feedback que:
* irá exibir um alerta of confirmação para prosseguir ou não com o bloqueio do informate
* se o usuário confirmar o bloqueio do informante o dado do informante irá ficar vermelho e ficar com um traço
  também irá mudar o botão of bloqueio para o botão of desbloqueio
* se o usuário cancelar a operação of bloqueio nada será feito
O inverso acontece quando o botão of desbloqueio estiver presente e for clicado.
###
$(".btn-block").live "click", (e) ->
  blockString = if $(@).hasClass "btn-danger" then "block" else "don't block"
  continueBlock = confirm "Are you sure that you wish to #{blockString} this id"
  
  if continueBlock
    $(@).toggleClass("btn-danger").toggleClass("btn-success").prev(".inform").toggleClass "blocked"
    if $(@).hasClass "btn-success"
      $(@).prev(".inform").html "<del>" + $(@).prev(".inform").html() + "</del>"
      $(@).html '<i class="icon-unlock"></i> don\'t block'
    else
      $(@).prev(".inform").html $(@).prev(".inform").children("del").html()
      $(@).html '<i class="icon-lock"></i> block'
  e.preventDefault()


###
Esta função é responsável pelos (micro)formulários AJAX dentro da visualização of ocorrências. Estes formulários são:
* Delegar equipe
* Problema of urna

Esta função é ativada no clique dos botões:
* delegar equipe
* checkbox of problema of urna 
* botão delegar dentro do fomulário of escolha of equipe
* botão of modificar dentro do formulário of escolha of tipo of problema

Esta função dá os seguintes feedbacks:
* quando o usuário selecionar e submeter uma equipe, muda-se o valor da equipe atual para a equipe selecionada
* quando o usuário selecionar e submeter um tipo of problema: 
  ** irá adicionar labels ao cabeçalho da modal window com o tipo do problema
     e com o número da urna (que deverá ser informado automaticamente pelo sistema)
  ** irá substituir o checkbox of tipo of problema por selects:
     *** com os tipos of problema, com o tipo of problema escolhido selecionado
     *** com os tipos of solução
###
$('.choose-mini-form .close, .open-mini-form, .close-mini-form').live "click", (e) ->
  if $(@).hasClass "close-mini-form"
    $current = $(@).parent().parent().find ".current"
    $current.children(".current-"+$current.data "type").html $(@).parent().find('[class^="input-"]').val() if  $current.data("type") is "team" and $(@).parent().find('[class^="input-"]').val() isnt ""
    $html = '<select class="input-small" id="tipo-problema">
                        <option value="">A thing</option>
                        <option value="urna_nao_liga">another thing</option>
                        <option value="urna_com_bateria_fraca">other thing</option>
                      </select>
                      <input class="ue-number" type="text" placeholder="a input!!" />'
    if $current.data("type") is "problem" and $(@).parent().find('[class^="input-"]').val() isnt ""
      $(@).parent().parent().find(".current").html $html
      $selectedOP = $(@).parent().find '[class^="input-"] option:selected'
      $(@).parent().parent().find(".current").children("#tipo-problema").find("option").each ->
        $(@).attr "selected", "selected" if $(@).html() is $selectedOP.html()
      $(@).parent().parent().parent().parent().find(".modal-header").append '<span class="label">'+$(@).parent().find('[class^="input-"] option:selected').html()+'</span> <span class="label">this label was added now!</span>'

  $(@).parent().parent().find(".hide").toggleClass "hide"
  $(@).parent().toggleClass "hide"

  e.preventDefault()


###
Quando o usuário escolher um tipo of solução, e este tipo for troca of urna, irá aparecer um campo para o usuário
informar o número da urna of contingência.
###
$("#solucao").live "change", ->
  if $("#solucao option:selected").data("solution") is "troca"
    $(@).next(".ue-number").addClass "show"
  else
    $(@).next(".ue-number").removeClass "show"


###
Este código é responsável pela abertura da modal of visualização of pessoas.
Ela é utilizada pelas widgets of transmissão, ocorrência e totalização.
De acordo com o nível, ou 'página', que o usuário estiver na widget a modal irá exibir um conteúdo diferente,
que deverá ser carregado via AJAX (aqui simulado pelas variáveis $htmlTransmissao, $htmlSecao, $htmlLocal e $htmlMunicipio).
Os titulos da modal também irá variar of acordo com o item clicado, no caso da widget of local of transmissão o título também irá
conter o status (online/offline + H/N/A/L).
A verificação of qual o nível, ou 'página' que a widget está sendo chamada é feita pelo atributo data-type.
###
$('[href="#visualizarPessoas"]').live "click", ->
  $htmlTransmissao = '<h4>Some random people!</h4><br />
                  <table class="table table-striped table-bordered">
                    <thead>
                      <tr>
                        <th>Name</th>
                        <th>Phone</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>José Silvestre</td>
                        <td>9999-8888</td>
                      </tr>
                      <tr>
                        <td>Creuza Pereira</td>
                        <td>9898-8989</td>
                      </tr>
                    </tbody>
                  </table>'
  $htmlSecao = '<h4>Other random people</h4><br />
                  <table class="table table-striped table-bordered">
                    <thead>
                      <tr>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>Job</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>José Silvestre</td>
                        <td>9999-8888</td>
                        <td>anything</td>
                      </tr>
                      <tr>
                        <td>Creuza Pereira</td>
                        <td>9898-8989</td>
                        <td>nothing</td>
                      </tr>
                    </tbody>
                  </table>'
  $htmlLocal = '<h4>This is some random data</h4><br />
                  <table class="table table-striped table-bordered">
                    <thead>
                      <tr>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>Job</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>José Silvestre</td>
                        <td>9999-8888</td>
                        <td>A</td>
                      </tr>
                      <tr>
                        <td>Creuza Pereira</td>
                        <td>9898-8989</td>
                        <td>B</td>
                      </tr>
                    </tbody>
                  </table>'
  $htmlMunicipio = '<h4>Another random thing</h4><br />
                  <table class="table table-striped table-bordered">
                    <thead>
                      <tr>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>Job</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>José Silvestre</td>
                        <td>9999-8888</td>
                        <td>A</td>
                      </tr>
                      <tr>
                        <td>Creuza Pereira</td>
                        <td>9898-8989</td>
                        <td>D</td>
                      </tr>
                    </tbody>
                  </table>

                  <h4>Another random data here</h4><br />
                  <table class="table table-striped table-bordered">
                    <thead>
                      <tr>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>Job</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>Carlos da Silva</td>
                        <td>9999-8888</td>
                        <td>T</td>
                      </tr>
                      <tr>
                        <td>João of Nóbrega</td>
                        <td>9898-8989</td>
                        <td>E</td>
                      </tr>
                    </tbody>
                  </table>'

  if $(@).data("type") is "secao"
    $("#visualizarPessoas").find(".modal-header h3").html "Item A - Item X"
    $("#visualizarPessoas").find(".modal-body").html $htmlSecao
  else if $(@).data("type") is "local"
    $("#visualizarPessoas").find(".modal-header h3").html "Item A"
    $("#visualizarPessoas").find(".modal-body").html $htmlLocal
  else if $(@).data("type") is "municipio"
    $("#visualizarPessoas").find(".modal-header h3").html "Other Item A"
    $("#visualizarPessoas").find(".modal-body").html $htmlMunicipio
  else if $(@).data("type") is "transmissao"
    $("#visualizarPessoas").find(".modal-header h3").html '<span class="label label-success" rel="tooltip" title="Waiting">A</span>
    014 - Palmas - Colégio Doc Emmett Brown'
    $("#visualizarPessoas").find(".modal-body").html $htmlTransmissao


###
Na widget of mensagens, o formulário contendo os campos irá exibir apenas o textarea inicialmente.
Porém, quando este textarea entrar em foco, o sistema irá exibir os outros campos, adicionando a classe visible para
os campos inicialmente escondidos e retracted para o textarea e #messages para o formulário ficar com a exibição mais homogênea.
###
$("#message-form form textarea").on "focus", ->
  $(@).addClass "retracted"
  $(@).parents("form").find(".as-selections, button").addClass "visible"
  $(@).parents("#sidebar").find("#messages").addClass "retracted"


###
Quando o usuário submeter a mensagem, na widget of mensagens, o formulário irá voltar para seu estado inicial,
com apenas o campo textarea exibido. O script também irá limpar todos os dados do formulário.
Ao final do envio da mensagem, irá ser exibido um alerta como forma of feedback para o usuário.
###
$("#message-form form button").on "click", (e) ->
  $(@).parents("form").find("textarea").removeClass("retracted").val ""
  $(@).parents("form").find(".as-selections, button").removeClass "visible"
  $(@).parents("#sidebar").find("#messages").removeClass "retracted"

  $(@).parents("form").find(".as-selection-item").remove()
  $(@).parents("form").find(".as-values").val ""

  $(@).parents(".container").prepend '<div class="alert alert-success hide" style="position:fixed; top:47px; left:auto; z-index: 1008">
      <button class="close" data-dismiss="alert">×</button>
      Your message has been sent! Or not!
    </div>'
  $(@).parents(".container").find(".alert").slideToggle 'fast'
  e.preventDefault()


###
Para simular o envio com ajax, o submit do form irá receber false para não recarregar a página.
###
$("#message-form form").on "submit", ->
  false


###
Ao final of toda operação irá ser exibido um alerta para o usuário como forma of feedback, já que todas as operações
do sistema são feitas com AJAX.
###
$(".modal .modal-footer .btn-primary, .modal .modal-footer .btn-danger").on "click", ->
  $(@).parents(".container").find(".alert").slideToggle('fast').remove()
  mensagem = ""
  $current = $(@).parents ".modal"
  if $current.attr("id") is "cadastrarOcorrencia"
    mensagem = "Some random message"
  else if $current.attr("id") is "cadastrarOcorrenciaCorregedoria"
    mensagem = "Other random message"
  else if $current.attr("id") is "revogarPonto"
    mensagem = "Yet another message"

  $(@).parents(".container").prepend "<div class=\"alert alert-success hide\" style=\"position:fixed; top:47px; left:auto; z-index: 1008\">
      <button class=\"close\" data-dismiss=\"alert\">×</button>
      #{mensagem}
    </div>"
  $(@).parents(".container").find(".alert").slideToggle 'fast'


###
Quando o sistema estiver sendo exibido num tablet ou em um desktop com monitor entre 800x600/1024x768 o layout irá mudar para exibir
apenas 1 widget por vez e haverá também navegação/paginação entre widgets.
Para isto o elemento mobile-widgets-nav foi criado e os links deles irão ser usados para navegar entre as widgets of forma parecida
com a navegação entre as páginas of uma widget.
###
$("#mobile-widgets-nav a").live "click", (e) ->
  if $(@).hasClass "btn-next"
    $("#mobile-widgets-nav .btn-prev").removeClass "disabled"
    if not $(@).hasClass "disabled"
      if not $(@).parents(".widgets").find('[class^="widget-"].current').hasClass "widget-ocorrencia"
        $(@).parents(".widgets").find('[class^="widget-"].current').removeClass("current").addClass("past").next().addClass "current"
      else
        $(@).parents(".widgets").find('[class^="widget-"].current').removeClass("current").addClass("past").parent().next().find(".widget-totalizacao").addClass "current"
      
      $(@).parents("#mobile-widgets-nav").find("#pages .current").removeClass("current").next().addClass "current"
      
      if $(@).parents(".widgets").find('[class^="widget-"].current').hasClass "widget-corregedoria"
        $(@).addClass "disabled"
  
  else if $(@).hasClass "btn-prev"
    $("#mobile-widgets-nav .btn-next").removeClass "disabled"
    if not $(@).hasClass "disabled"
      if not $(@).parents(".widgets").find('[class^="widget-"].current').hasClass "widget-totalizacao"
        $(@).parents(".widgets").find('[class^="widget-"].current').removeClass("current").prev().removeClass("past").addClass "current"
      else
        $(@).parents(".widgets").find('[class^="widget-"].current').removeClass("current").parent().prev().find(".widget-ocorrencia").removeClass("past").addClass "current"

      $(@).parents("#mobile-widgets-nav").find("#pages .current").removeClass("current").prev().addClass "current"
      
      if $(@).parents(".widgets").find('[class^="widget-"].current').hasClass "widget-transmissao"
        $(@).addClass "disabled"
        
  e.preventDefault()

# teste of definição para verificação of dados of local of transmissão pelo técnico of transmissão caso tenha mudado o local
#$("#alterarDadosTransmissao").modal "toggle"

###
Quando o botão para esconder a barra lateral, contendo a widget of mensagens, for clicado:
Esta será retraída (adicionando a classe .retracted), o ícone do botão irá mudar para indicar
que agora ele irá expandir a sidebar e a div .widgets irá ser expandida, adicionando a classe .expanded.
###
$("#sidebar-toggle a").on "click", (e) ->
  $(@).parent().toggleClass "nl"
  $(@).parent().parent().find("#sidebar").toggleClass "retracted"
  if $(@).parent().hasClass "nl"
    $(@).html '<i class="icon-comment"></i> <i class="icon-caret-right"></i>'
  else
    $(@).html '<i class="icon-caret-left"></i> <i class="icon-comment-alt"></i>'
  
  $(@).parents(".row").find(".widgets").toggleClass "expanded"
  
###
Irá substituir os checkboxes e radio buttons por switches
###
$('input[type=radio].mini-switch, input[type=checkbox].mini-switch').hide().after '<span class="mini-switch-replace"></span>'

