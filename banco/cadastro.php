<?php 
header("Access-Control-Allow-Origin: http://localhost:57803");
include 'conexao.php';
try{
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {

        $id_usuario = $_POST['idusuario'];
        $nome = $_POST['nome'];
        $cpf = $_POST['cpf'];
        $data_nasc = $_POST['datanasc'];
        $telefone = $_POST['telefone'];
        $email = $_POST['email'];
        $senha = $_POST['senha'];
        $necessidade = $_POST['necessidade'];
        

        $sql = "INSERT INTO tb_usuario (idusuario, nome, cpf, datanasc, telefone, email, senha, necessidade) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("isidisss", $id_usuario, $nome, $cpf, $data_nasc, $telefone, $email, $senha, $necessidade);
        
        if ($stmt->execute()) {
            echo json_encode(["sucesso" => 'Usuário inserido com sucesso!']);
        } else {
            echo json_encode(["erro" => 'Erro ao inserir o usuário: ' . $stmt->error]);
        }
        $stmt->close();
    }
    } catch (mysqli_sql_exception $e) {
        error_log("Erro ao conectar ao banco de dados: " . $e->getMessage());
        echo "Ocorreu um erro ao conectar ao banco de dados. Por favor, tente novamente mais tarde.";
    }
?>