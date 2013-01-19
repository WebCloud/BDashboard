###
creates the subnav fixation effect.
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
Add the 'expand' feature to the widgets.
When the button is clicked the .expanded class will be added to the targeted widgtet.
###    
$(".expander").on "click", (e) ->
  $(@).parents('[class^="widget-"]').toggleClass "expanded"
  e.preventDefault()
  

###
Add the configuration pannel to the widgets.
When the button is clicked the .open class will be added to the settings pannel, and with that, making it visible.
### 
$(".settings-nub").on "click", (e) ->
  $(@).toggleClass("open").parent().parent().find(".settings").toggleClass "open"
  e.preventDefault()


###
Close the configurations pannel when the filter button is clicked.
### 
$(".settings button").on "click",(e) ->
  if $(@).hasClass "btn-filtro"
    $(@).parent().parent().parent().find(".settings-nub, .settings").toggleClass "open"
  e.preventDefault()


###
ADd the tooltip initializer, using the bootstrap's native plugin.
### 
$("[rel='tooltip']").tooltip()


###
Add the autocomplete feature to the elements with the .chosen class.
This autocomplete DOES NOT feature AJAX calls, it mounts the autocompletion based on the list itens of a ul or select elements.
The chosen plugin is at js/chosen.jquery.min.js
### 
$(".chosen").chosen {no_results_text: "No result found"}


###
Making some bootstrap data to be used on the AJAX autocomplete.
### 
data = {items: [
  {value: "21", name: "A item"},
  {value: "43", name: "Another item"},
  {value: "46", name: "Some other fake item"},
  {value: "54", name: "Yet another fake item"}
  ]}


###
Adds the AJAX autocomplete feature, with multiple selections, to the elements with the .autocomplete class and to the #message-form input on the messages widget.
This code uses the AutoSuggest plugin, it is at js/jquery.autosugest.min.js
### 
$(".autocomplete").autoSuggest data.items, {selectedItemProp: "name", searchObjProps: "name", startText: "Add filter", emptyText: "No results", limitText: "You can't make another selection", minChars: 2, selectionLimit: 3}
$("#message-form input").autoSuggest data.items, {selectedItemProp: "name", searchObjProps: "name", startText: "Send to", emptyText: "No results", limitText: "You can't make another selection", minChars: 2, selectionLimit: 3}


###
Add the focus/blur effect to the autocomplete, to mimmic the native bootstrap look.
###
$(".as-selections input").focus(->
    $(@).parent().parent().addClass "focus"
  ).blur ->
    $(@).parent().parent().removeClass "focus"


###
Add the single item autocomplete, with ajax, feature, targeted to the mun-autocomplete class.
This code uses the bootstrap.typeahead that is included on the js/bootstrap.min.js file.
###
$(".mun-autocomplete").typeahead {
    source: [
        'A place',
        'Another place',
        'Some other place'
    ]
  }


###
Add the online/offline filter feature to the first widget.
When one of the filter buttons is clicked, it will add the .active class to the clicked button and the elements with the data-trans-status not equal to it's data-trans-status will be hidden.
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
Expands the options to the items that has the .has-item-options class.
###
$(".code-wrap .has-item-options li > a").live "click", (e) ->
  $(@).next(".item-options").slideToggle "fast"
  $(@).parent("li").has(".item-options").toggleClass "active"
  e.preventDefault()


###
When a button on the expanded pannel of the itens is clicked, the expanded pannel is closed to mimmic a performed action.
###
$(".option-open, .option-close").live "click", (e) ->
  $(@).parent().slideUp "fast"
  $(@).parent().parent("li").toggleClass "active"
  e.preventDefault()


###
Add the 'level navigation' feature to the widgets.
This widget simulates a AJAX call, of the next level's items, with the setTimeout function. 
To this concept, the initial code of the next level would already be present on the 'final' HTML
with the #step-x id, being 'x' the pagination number that the level will be. Only the content would be loaded via an AJAX call.
eg.:

<div class='content-wrap'>
  <div class='step-1 current'>
    <!-- visible div on the screen -->
  </div>
  <div class='step-2'>
   <!-- hidden div, that will have it's content loaded via AJAX -->
  </div>
  <div class='step-3'>
   <!-- hidden div, that will have it's content loaded via AJAX -->
  </div>
  ...
</div>

With a real AJAX call, after the call of the $(this).parents('[class^="widget-"]').find(".loading").addClass("open") part,
on the method's success event the final HTML with the content would be injected as response a the div $('.step-x').next('.step-x+1').html($meuHTMLdeResposta).
Following that, the procedures that are executed at the setTimeout function are trigged to animate and hide the pannel with the loading indicator.

The HTML formatting must be as the example above, and the one found at the HTML.
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
Add the 'back to the previous level' feature to the widgets that have the 'level navigation'.
To return to the previous level there is no AJAX call. Just straight up DOM manipulation and visual effects. Because the previous page is 'hidden' at the left of the current page. 
The current page will be marked with the .current class, and the pages that where active will be marked with the .past class.
The 'next' levels don't need any other class that is not the .step-x class.
ex.:

<div class='content-wrap'>
  <div class='step-1 past'>
    <!-- hidden div, that has the populated DOM -->
  </div>
  <div class='step-2 past'>
    <!-- hidden div, that has the populated DOM -->
  </div>
  <div class='step-3 current'>
    <!-- currently visible div on the screen -->
  </div>
  <div class='step-4'>
    <!-- hidden div, that will have it's content loaded via AJAX -->
  </div>
  ...
</div>
###
$(".btn-prev").live "click", (e) ->
  $(@).parent().removeClass("current").prev().addClass("current").removeClass "past"
  e.preventDefault()


###
Add the 'toggle view mode' to the widgets.
This method mimmics the injection of HTML ($htmlOcorrencia, $htmlSecao, $$htmlLocal e $htmlSecaoTot) from a AJAX call.
This function is used by the two states of the view mode.
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
This is the function to simulate multiple actions on the form of the second widget. Just add/remove some extra options when the checkboxes are toggled.
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
Mimmics a blocking action on the modal window visualzation of the second widget.
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
This function add/remove itens on the modal window visualization of the second widget.
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
More dummy stuff on the modal window visualization of the second widget.
###
$("#solucao").live "change", ->
  if $("#solucao option:selected").data("solution") is "troca"
    $(@).next(".ue-number").addClass "show"
  else
    $(@).next(".ue-number").removeClass "show"


###
This function mimmics the AJAX injection of data (aqui simulado pelas variáveis $htmlTransmissao, $htmlSecao, $htmlLocal e $htmlMunicipio) on the 'view data' buttons of some items.
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
This retracts/shows the #message-form
###
$("#message-form form textarea").on "focus", ->
  $(@).addClass "retracted"
  $(@).parents("form").find(".as-selections, button").addClass "visible"
  $(@).parents("#sidebar").find("#messages").addClass "retracted"


###
This resets the #message-form to it's original state when the submit button is clicked.
Also, it shows a little notification.
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
Just avoid the form submition.
###
$("#message-form form").on "submit", ->
  false


###
This function is responsible to show a notification when a form is submitted.
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
This adds a specila navigation to the resolutions between 800x600/1024x768.
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


###
This function toggles the messages widget.
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
This function will replace the targeted radio buttons to a specil 'switch' element.
###
$('input[type=radio].mini-switch, input[type=checkbox].mini-switch').hide().after '<span class="mini-switch-replace"></span>'

