<?php

if ($_SERVER["REQUEST_METHOD"] === "POST"){
    $NIK = $_POST["NIK"];
    $password = $_POST["password"];
    $role = $_POST["role"];

    if ($role === "pasien"){
        try {
            require_once 'dbhinc.php';
            require_once 'login_controllerinc.php';
            require_once 'login_modelinc.php';

            //ERROR HANDLER
            $errors = [];

            if(is_input_empty($NIK, $password, $role)){
                $errors["empty_input"] = "Fill in all fields!";
            }

            // Determine which user type to check
            $result = get_user_pasien($pdo, $NIK, $role);

            if (!$errors && is_NIK_invalid($result)){
                $errors["login_incorrect"] = "Incorrect login info!";
            }

            if (!$errors && !is_NIK_invalid($result) && is_password_invalid($password, $result["password"])){
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
            $_SESSION["user_NIK"] = htmlspecialchars($result["NIK"]);

            $_SESSION["last_regeneration"] = time();

            // After successful login
            $_SESSION["user_NIK"] = htmlspecialchars($result["NIK"]);

            //login success
            header("Location: ../userdashboard.php?login=success");
            
            $pdo = null;
            $stmt = null;

            die();
        } catch (PDOException $e) {
            die("Query failed: " . $e->getMessage());
        }
    }else{
        try {
            require_once 'dbhinc.php';
            require_once 'login_controllerinc.php';
            require_once 'login_modelinc.php';

            //ERROR HANDLER
            $errors = [];

            if(is_input_empty($NIK, $password, $role)){
                $errors["empty_input"] = "Fill in all fields!";
            }

            // Determine which user type to check
            $result = get_user_tenagamedis($pdo, $NIK, $role);
            
            if (!$errors && is_NIK_invalid($result)){
                $errors["login_incorrect"] = "Incorrect username!";
            }

            if (!$errors && !is_NIK_invalid($result) && is_password_invalid($password, $result["password"])){
                $errors["login_incorrect"] = "Incorrect password!";
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
            $_SESSION["user_NIK"] = htmlspecialchars($result["NIK"]);

            $_SESSION["last_regeneration"] = time();

            //login success
            // header("Location: ../userdashboard.php?login=success");
            $pdo = null;
            $stmt = null;

            die();
        } catch (PDOException $e) {
            die("Query failed: " . $e->getMessage());
        }
    }
} else {
    header("Location: ../login.php");
    die();
}