<?php
// Designed to test Service Provider Authentication
//
// Glaidson Verzeletti
// <verzeletti (at) gmail (dot) com>
//
// Last Changes: 2021-08-19
//
// Reference: https://simplesamlphp.org/docs/stable/simplesamlphp-sp
// Another sample: https://sp.ufrgs.br/tutoriais/simplesaml.html


// Just OID references
//define("uid",         'urn:oid:0.9.2342.19200300.100.1.1');
//define("cn",          'urn:oid:2.5.4.3');
//define("displayName", 'urn:oid:2.16.840.1.113730.3.1.241');
//define("mail",        'urn:oid:0.9.2342.19200300.100.1.3');

// Just some html tags :)
echo '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">';
echo '<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></head>';
echo '<title>Service Provider - Test Script</title><body>';
echo '<dd><h2>Aplicação PHP integrada ao SimpleSAML - Teste do SP (Service Provider)</h2>';
echo '<br><h3><b>Atributos entregues pelo IdP:</b></h3>';

// Loading a file which registers the SimpleSAMLphp classes with the autoloader
require_once('../simplesamlphp/lib/_autoload.php');


// Select authentication source
$SP="disciplinas-sp";
$_POST['serviceprovider'] = $SP;
$as = new \SimpleSAML\Auth\Simple($SP);


// Require authentication
$as->requireAuth();


// Get attributes from IdP:
$attributes = $as->getAttributes();


// Print all attributes
//print_r($attributes);

// Print all attributes friendly
//
echo '<font size="4">';
print(htmlspecialchars( "Nome (givenName)____________ " . $attributes['givenName'][0]) . "<br>");
print(htmlspecialchars( "Sobrenome (sn)_______________ " . $attributes['sn'][0]) . "<br>");
print(htmlspecialchars( "Nome Completo (displayName)__ " . $attributes['displayName'][0]) . "<br>");
print(htmlspecialchars( "Login (uid)___________________ " . $attributes['uid'][0]) . "<br>");
print(htmlspecialchars( "Email (mail)__________________ " . $attributes['mail'][0]) . "<br>");
print(htmlspecialchars( "Carreira (title)_________________ " . $attributes['title'][0]) . "<br>");


// Request authentication with a specific IdP
// Not necessary in this context
//$as->login([
//   'saml:idp' => 'https://idp.lages.ifsc.edu.br/',
//]);


// More some html tags :)
?>
<br><br>
<h3>O que deseja fazer?</h3>
Testar acesso à uma "<a href="sp-approval_pg01.php?serviceprovider=<?php echo "$SP";?>">Aplicação Protegida</a>"
<br><br>
>> <a href="/simplesaml/module.php/core/authenticate.php?as=<?php echo "$SP"; ?>&logout">Encerrar Sessão</a> <<
</font></dd><br></body></html>
