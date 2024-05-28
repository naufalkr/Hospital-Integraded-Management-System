<?php

if ($_SERVER["REQUEST_METHOD"] === "POST"){
    $username = $_POST["username"];
    $password = $_POST["password"];
    $role = $_POST["role"];

    try {
        require_once 'dbhinc.php';
        require_once 'login_controllerinc.php';
        require_once 'login_modelinc.php';

        //ERROR HANDLER
        $errors = [];

        if(is_input_empty($username, $password, $role)){
            $errors["empty_input"] = "Fill in all fields!";
        }

        $result = get_user($pdo, $username, $role);
        if(is_username_invalid($result)){
            $errors["login_incorrect"] = "Incorrect login info!";
        }

        if(!is_username_invalid($result) && is_password_invalid($password, $result["password"])){
            $errors["login_incorrect"] = "Incorrect login info!";
        }

        require_once 'config_sessioninc.php';

        if($errors){
            $_SESSION["errors_login"] = $errors;

            header("Location: ../login.php");
            die();
        }

        //Security measure using user id
        $newSessionId = session_create_id();
        $sessionId = $newSessionId . "_" . $result["id"];
        session_id($sessionId);

        $_SESSION["user_id"] = $result["id"];
        $_SESSION["user_username"] = htmlspecialchars($result["username"]);

        $_SESSION["last_regeneration"] = time();

        //login success
        header("Location: ../dashboard.php?login=success");
        $pdo = null;
        $stmt = null;

        die();
    } catch (PDOException $e) {
        die("Query failed: " . $e->getMessage());
    }
} else {
    header("Location: ../login.php");
    die();
}