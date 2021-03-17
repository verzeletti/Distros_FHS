<?php
// Exemplo retirado de - https://simplesamlphp.org/docs/stable/simplesamlphp-sp
// Outro exemplo em - https://sp.ufrgs.br/tutoriais/simplesaml.html
//
// Escrito em 15/03/2021 - verzeletti at gmail dot com
// Validacao de Service Provider (SP) com uso de FrameWork simpleSAMLphp


//define("uid",         'urn:oid:0.9.2342.19200300.100.1.1');
//define("cn",          'urn:oid:2.5.4.3');
//define("displayName", 'urn:oid:2.16.840.1.113730.3.1.241');
//define("mail",        'urn:oid:0.9.2342.19200300.100.1.3');

// carrega o arquivo que registra as classes do SimpleSAMLphp com o autoloader
require_once('../simplesamlphp/lib/_autoload.php');

//define o servico que sera autenticado
$as = new SimpleSAML_Auth_Simple('sistemaslages-sp');

//obriga que a pagina abaixo somente seja executada por um usuário autenticado
$as->requireAuth();
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<h2>Exemplo de Aplicação PHP + SimpleSAML</h2>

<?php
//real utilizaçao dos valores obtidos na autenticação:
//Cria um array de atributos
$attributes = $as->getAttributes();

// imprime todos atributos recebidos
//print_r($attributes);

//imprime os atributos especificos
//echo "<br>";
//echo "Login --> {$attributes['uid']}";
print(htmlspecialchars( "Nome (displayName attribute): " . $attributes['displayName'][0]) . "<br>");
print(htmlspecialchars( "Login (uid attribute): " . $attributes['uid'][0]) . "<br>");
//print(htmlspecialchars( "cn: " . $attributes['cn'][0]) . "<br>");
print(htmlspecialchars( "Email (mail attribute) : " . $attributes['mail'][0]) . "<br>");
print(htmlspecialchars( "Carreira (title attribute) : " . $attributes['title'][0]) . "<br>");
?>

<br><br>
<a href="sp-approval_pg01.php">Aplicacao protegida</a>

<br><br>
<a href="/simplesaml/module.php/core/authenticate.php?as=sistemaslages-sp&logout">(Encerrar Sessao)</a>

<br>
</body>
</html>
