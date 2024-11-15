<?php
header("Access-Control-Allow-Origin: http://localhost:57803");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");

$banco = 'db_mobility';
$host = 'localhost';
$usuario = 'root';
$senha = '';

date_default_timezone_set('America/Sao_Paulo');

try {
    $mysqli = new mysqli($host, $usuario, $senha, $banco);
} catch (mysqli_sql_exception $e) {
    error_log("Erro ao conectar ao banco de dados: " . $e->getMessage());
    echo "Ocorreu um erro ao conectar ao banco de dados. Por favor, tente novamente mais tarde.";
}
?>