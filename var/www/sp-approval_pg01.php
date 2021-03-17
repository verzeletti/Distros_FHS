<?php
// Exemplo de pagina protegida
//
// Escrito em 15/03/2021 - verzeletti at gmail dot com
// Validacao de Service Provider (SP) com uso de FrameWork simpleSAMLphp

// carrega o arquivo que registra as classes do SimpleSAMLphp com o autoloader
require_once('../simplesamlphp/lib/_autoload.php');

//define o servico que sera autenticado
$as = new SimpleSAML_Auth_Simple('sistemaslages-sp');

//obriga que a pagina abaixo somente seja executada por um usuário autenticado
$as->requireAuth();


//$session = \SimpleSAML\Session::getSessionFromRequest();
$session = SimpleSAML_Session::getSessionFromRequest();
$session->cleanup();


echo "<h2>Pagina protegida da aplicacao !!!</h2>";

echo "Se vc esta vendo esta informacao e existe uma sessao aberta no IdP esta tudo Ok!";

?>

<html>
<br><br><br>

<a href="/simplesaml/module.php/core/authenticate.php?as=sistemaslages-sp&logout">(Encerrar Sessao)</a>
</html>
