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


// Just html tags
echo "<html><title>Teste de Provedor de Serviço</title><body><dd>";


// Variables (GET or POST)
if (!is_null($_GET['serviceprovider'])) {
	$SP = $_GET['serviceprovider'];
} elseif (!is_null($_POST['serviceprovider'])) {
	$SP = $_POST['serviceprovider'];
} else {
	$SP = "not_session";	
	echo "<dd><b><h2>Ops! Desculpe, mas algo saiu errado.</h2></b></dd>";
	return false;
}


// Loading a file which registers the SimpleSAMLphp classes with the autoloader
require_once('../simplesamlphp/lib/_autoload.php');


// Select authentication source
$as = new \SimpleSAML\Auth\Simple($SP);


// Require authentication
$as->requireAuth();


// Session Control
// Make any calls to SimpleSAMLphp. For more informations about it, see reference link above

// use SimpleSAML\Session
$session = \SimpleSAML\Session::getSessionFromRequest();
$session->cleanup();
session_write_close();

// use custom save handler
//session_set_save_handler($handler);
//session_start();

// close session and restore default handler
//session_write_close();
//session_set_save_handler(new SessionHandler(), true);

// back to custom save handler
//session_set_save_handler($handler);
//session_start();


// Print some errors if they exist and are available
error_reporting(E_ALL);
ini_set("display_errors", 1);		


// Some html
echo "<h2>Página de teste - Aplicação Protegida</h2>";
echo "<br><br><font size=5 color=blue>";
echo "Se vc esta vendo esta informação e, existe uma sessão válida no IdP, está tudo Ok!";
echo "<br></font>";
?>
<!-- More html -->
<br><br><br><font size="4">
>> <a href="sp-approval.php">Retornar à Página Inicial</a> <<
</font></dd>
