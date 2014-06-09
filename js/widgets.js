var ocorrencias = [
  {
    titulo:'Chamado de testes',
    id:1,
    descricao:'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    informante:'9999-8888',
    parada:true,
    mesario:false
  },
  {
    titulo:'Outro chamado de testes',
    id:1,
    descricao:'Lorem ipsum dolor sit amet.',
    informante:'9988-8899',
    parada:false,
    mesario:true
  }
];


var secoes = [
	{num:123, id:1, cont:4, parada:true, mesario:false, ocorrencias:ocorrencias},
	{num:321, id:2, cont:12, parada:false, mesario:false, ocorrencias:ocorrencias},
	{num:111, id:3, cont:4, parada:false, mesario:true, ocorrencias:ocorrencias},
	{num:222, id:4, cont:12, parada:false, mesario:false, ocorrencias:ocorrencias},
	{num:333, id:5, cont:12, parada:false, mesario:false, ocorrencias:ocorrencias},
	{num:231, id:6, cont:4, parada:true, mesario:false, ocorrencias:ocorrencias}
];

var locais = [
	{nome:"Escola de testes", id:1, cont:5, parada:true, mesario:false, secoes:secoes}
];

var municipios = [
	{nome:"Município de Testes", id:1, cont:12, parada:true, mesario:false, locais:locais},
	{nome:"Outro município de Testes", id:2, cont:1, parada:false, mesario:true, locais:locais}
];

localStorage.setItem("widgets.localidades", JSON.stringify(municipios));

var widgets = angular.module('widgets', []);