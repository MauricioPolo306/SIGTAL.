<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
String error = (String) request.getAttribute("error");
String usuarioIngresado =
(String) request.getAttribute("usuarioIngresado");

if (usuarioIngresado == null) {
    usuarioIngresado = "";
}

%>

<!DOCTYPE html>

<html lang="es">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>SIGTAL - Iniciar sesión</title>

<!-- Lucide Icons -->
<script src="https://unpkg.com/lucide@latest"></script>

<style>

    /* ==========================================
       CONFIGURACIÓN GENERAL
       ========================================== */

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: Arial, Helvetica, sans-serif;

        min-height: 100vh;

        background:
            linear-gradient(
                rgba(0, 0, 0, 0.65),
                rgba(0, 0, 0, 0.70)
            ),
            url("<%= request.getContextPath() %>/fondo.png")
            center center / cover no-repeat fixed;

        display: flex;
        align-items: center;
        justify-content: center;

        padding: 20px;
    }


    /* ==========================================
       CONTENEDOR
       ========================================== */

    .login-container {
        width: 100%;
        max-width: 430px;
    }


    /* ==========================================
       TARJETA
       ========================================== */

    .login-card {
        background: rgba(255, 255, 255, 0.97);

        border-radius: 20px;

        padding: 40px 35px;

        box-shadow:
            0 20px 50px rgba(0, 0, 0, 0.35);

        animation: aparecer 0.5s ease;
    }


    @keyframes aparecer {

        from {
            opacity: 0;
            transform: translateY(20px);
        }

        to {
            opacity: 1;
            transform: translateY(0);
        }

    }


    /* ==========================================
       LOGO
       ========================================== */

    .logo {
        width: 70px;
        height: 70px;

        margin: 0 auto 18px;

        border-radius: 18px;

        display: flex;
        align-items: center;
        justify-content: center;

        background: #1d4ed8;

        color: white;

        box-shadow:
            0 10px 25px rgba(29, 78, 216, 0.30);
    }

    .logo svg {
        width: 38px;
        height: 38px;
    }


    /* ==========================================
       TITULO
       ========================================== */

    .titulo {
        text-align: center;

        color: #111827;

        font-size: 28px;

        font-weight: 700;

        margin-bottom: 7px;
    }

    .subtitulo {
        text-align: center;

        color: #6b7280;

        font-size: 14px;

        margin-bottom: 30px;

        line-height: 1.5;
    }


    /* ==========================================
       CAMPOS
       ========================================== */

    .campo {
        margin-bottom: 20px;
    }

    .campo label {
        display: block;

        color: #374151;

        font-size: 14px;

        font-weight: 600;

        margin-bottom: 8px;
    }


    .input-container {
        position: relative;
    }


    .input-container > svg {
        position: absolute;

        left: 14px;
        top: 50%;

        transform: translateY(-50%);

        width: 19px;
        height: 19px;

        color: #6b7280;

        pointer-events: none;
    }


    .input-container input {
        width: 100%;

        height: 50px;

        padding: 0 45px;

        border: 1px solid #d1d5db;

        border-radius: 10px;

        outline: none;

        font-size: 15px;

        background: #ffffff;

        transition:
            border-color 0.2s,
            box-shadow 0.2s;
    }


    .input-container input:focus {
        border-color: #2563eb;

        box-shadow:
            0 0 0 3px rgba(37, 99, 235, 0.12);
    }


    /* ==========================================
       MOSTRAR CONTRASEÑA
       ========================================== */

    .toggle-password {
        position: absolute;

        right: 12px;
        top: 50%;

        transform: translateY(-50%);

        border: none;

        background: transparent;

        color: #6b7280;

        cursor: pointer;

        width: 32px;
        height: 32px;

        display: flex;

        align-items: center;
        justify-content: center;

        border-radius: 7px;
    }


    .toggle-password:hover {
        background: #f3f4f6;

        color: #111827;
    }


    .toggle-password svg {
        width: 18px;
        height: 18px;
    }


    /* ==========================================
       OPCIONES DE LOGIN
       ========================================== */

    .opciones-login {
        display: flex;

        align-items: center;

        justify-content: space-between;

        margin-top: -5px;

        margin-bottom: 20px;
    }


    .recordar-usuario {
        display: flex;

        align-items: center;

        gap: 8px;

        color: #4b5563;

        font-size: 13px;

        cursor: pointer;

        user-select: none;
    }


    .recordar-usuario input {
        width: 16px;
        height: 16px;

        margin: 0;

        cursor: pointer;

        accent-color: #1d4ed8;
    }


    .recordar-usuario span {
        cursor: pointer;
    }


    /* ==========================================
       MENSAJE DE ERROR
       ========================================== */

    .mensaje-error {
        display: flex;

        align-items: center;

        gap: 9px;

        background: #fef2f2;

        color: #b91c1c;

        border: 1px solid #fecaca;

        border-radius: 10px;

        padding: 12px 14px;

        margin-bottom: 20px;

        font-size: 14px;

        line-height: 1.4;
    }


    .mensaje-error svg {
        width: 19px;
        height: 19px;

        flex-shrink: 0;
    }


    /* ==========================================
       BOTÓN LOGIN
       ========================================== */

    .boton-login {
        width: 100%;

        height: 50px;

        border: none;

        border-radius: 10px;

        background: #1d4ed8;

        color: white;

        font-size: 15px;

        font-weight: 700;

        cursor: pointer;

        display: flex;

        align-items: center;

        justify-content: center;

        gap: 9px;

        transition:
            background 0.2s,
            transform 0.1s,
            opacity 0.2s;
    }


    .boton-login:hover {
        background: #1e40af;
    }


    .boton-login:active {
        transform: scale(0.99);
    }


    .boton-login:disabled {
        cursor: not-allowed;

        opacity: 0.85;
    }


    .boton-login svg {
        width: 19px;
        height: 19px;
    }


    /* ==========================================
       RECUPERAR CONTRASEÑA
       ========================================== */

    .recuperar-password {
        text-align: center;

        margin-top: 20px;
    }


    .recuperar-password a {
        display: inline-flex;

        align-items: center;

        justify-content: center;

        gap: 6px;

        color: #1d4ed8;

        text-decoration: none;

        font-size: 13px;

        font-weight: 600;

        transition:
            color 0.2s,
            transform 0.2s;
    }


    .recuperar-password a:hover {
        color: #1e40af;

        text-decoration: underline;
    }


    .recuperar-password svg {
        width: 16px;
        height: 16px;
    }


    /* ==========================================
       FOOTER
       ========================================== */

    .footer-login {
        text-align: center;

        margin-top: 25px;

        color: #9ca3af;

        font-size: 12px;

        line-height: 1.6;
    }


    .footer-login strong {
        color: #6b7280;
    }


    /* ==========================================
       LOADER
       ========================================== */

    .loader {
        display: none;

        width: 18px;
        height: 18px;

        border: 2px solid rgba(255, 255, 255, 0.4);

        border-top-color: white;

        border-radius: 50%;

        animation: girar 0.7s linear infinite;
    }


    @keyframes girar {

        to {
            transform: rotate(360deg);
        }

    }


    .boton-login.cargando .icono-login {
        display: none;
    }


    .boton-login.cargando .loader {
        display: block;
    }


    /* ==========================================
       RESPONSIVE
       ========================================== */

    @media (max-width: 480px) {

        body {
            padding: 15px;
        }

        .login-card {
            padding: 32px 24px;

            border-radius: 16px;
        }

        .titulo {
            font-size: 25px;
        }

        .subtitulo {
            font-size: 13px;
        }

    }

</style>

</head>

<body>

<div class="login-container">


    <div class="login-card">


        <!-- ======================================
             LOGO
             ====================================== -->

        <div class="logo">

            <i data-lucide="wrench"></i>

        </div>


        <!-- ======================================
             TITULO
             ====================================== -->

        <h1 class="titulo">
            SIGTAL
        </h1>


        <p class="subtitulo">
            Sistema Integral de Gestión para Taller Automotriz
        </p>


        <!-- ======================================
             MENSAJE DE ERROR
             ====================================== -->

        <% if (error != null && !error.isEmpty()) { %>

            <div class="mensaje-error">

                <i data-lucide="circle-alert"></i>

                <span>
                    <%= error %>
                </span>

            </div>

        <% } %>


        <!-- ======================================
             FORMULARIO
             ====================================== -->

        <form
            action="<%= request.getContextPath() %>/login"
            method="POST"
            id="formLogin"
        >


            <!-- ==================================
                 USUARIO
                 ================================== -->

            <div class="campo">

                <label for="usuario">
                    Usuario
                </label>


                <div class="input-container">

                    <i data-lucide="user"></i>


                    <input
                        type="text"
                        id="usuario"
                        name="usuario"
                        placeholder="Ingrese su usuario"
                        value="<%= usuarioIngresado %>"
                        autocomplete="username"
                        required
                        autofocus
                    >

                </div>

            </div>


            <!-- ==================================
                 CONTRASEÑA
                 ================================== -->

            <div class="campo">

                <label for="password">
                    Contraseña
                </label>


                <div class="input-container">

                    <i data-lucide="lock-keyhole"></i>


                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Ingrese su contraseña"
                        autocomplete="current-password"
                        required
                    >


                    <button
                        type="button"
                        class="toggle-password"
                        id="btnPassword"
                        onclick="mostrarPassword()"
                        aria-label="Mostrar contraseña"
                    >

                        <i data-lucide="eye"></i>

                    </button>

                </div>

            </div>


            <!-- ==================================
                 RECORDAR USUARIO
                 ================================== -->

            <div class="opciones-login">

                <label class="recordar-usuario">

                    <input
                        type="checkbox"
                        id="recordarUsuario"
                        name="recordarUsuario"
                    >

                    <span>
                        Recordar usuario
                    </span>

                </label>

            </div>


            <!-- ==================================
                 BOTÓN INICIAR SESIÓN
                 ================================== -->

            <button
                type="submit"
                class="boton-login"
                id="btnLogin"
            >

                <i
                    data-lucide="log-in"
                    class="icono-login"
                ></i>


                <span class="texto-login">
                    Iniciar sesión
                </span>


                <span class="loader"></span>

            </button>


            <!-- ==================================
                 RECUPERAR CONTRASEÑA
                 ================================== -->

            <div class="recuperar-password">

                <a
                    href="<%= request.getContextPath() %>/recuperar-password"
                >

                    <i data-lucide="key-round"></i>

                    <span>
                        ¿Olvidaste tu contraseña?
                    </span>

                </a>

            </div>


        </form>


        <!-- ======================================
             FOOTER
             ====================================== -->

        <div class="footer-login">

            <strong>
                TALLER LONDOÑO
            </strong>

            <br>

            Sistema SIGTAL © 2026

        </div>


    </div>

</div>


<!-- ==========================================
     JAVASCRIPT
     ========================================== -->

<script>


    /* ==========================================
       INICIALIZAR ICONOS
       ========================================== */

    if (window.lucide) {

        lucide.createIcons();

    }


    /* ==========================================
       ELEMENTOS
       ========================================== */

    const campoUsuario =
        document.getElementById("usuario");

    const campoPassword =
        document.getElementById("password");

    const recordarUsuario =
        document.getElementById("recordarUsuario");

    const formLogin =
        document.getElementById("formLogin");

    const botonLogin =
        document.getElementById("btnLogin");


    /* ==========================================
       CARGAR USUARIO RECORDADO
       ========================================== */

    document.addEventListener(
        "DOMContentLoaded",
        function () {

            const usuarioGuardado =
                localStorage.getItem("sigtal_usuario");

            if (usuarioGuardado) {

                campoUsuario.value =
                    usuarioGuardado;

                recordarUsuario.checked =
                    true;

            }

        }
    );


    /* ==========================================
       MOSTRAR / OCULTAR CONTRASEÑA
       ========================================== */

    function mostrarPassword() {

        const botonPassword =
            document.getElementById("btnPassword");


        if (campoPassword.type === "password") {

            campoPassword.type = "text";


            botonPassword.innerHTML =
                '<i data-lucide="eye-off"></i>';


            botonPassword.setAttribute(
                "aria-label",
                "Ocultar contraseña"
            );

        } else {

            campoPassword.type = "password";


            botonPassword.innerHTML =
                '<i data-lucide="eye"></i>';


            botonPassword.setAttribute(
                "aria-label",
                "Mostrar contraseña"
            );

        }


        if (window.lucide) {

            lucide.createIcons();

        }

    }


    /* ==========================================
       RECORDAR USUARIO
       ========================================== */

    formLogin.addEventListener(
        "submit",
        function () {


            if (recordarUsuario.checked) {

                localStorage.setItem(
                    "sigtal_usuario",
                    campoUsuario.value.trim()
                );

            } else {

                localStorage.removeItem(
                    "sigtal_usuario"
                );

            }


            /* ==============================
               ANIMACIÓN DE CARGA
               ============================== */

            botonLogin.classList.add(
                "cargando"
            );


            botonLogin.disabled = true;


            const texto =
                botonLogin.querySelector(
                    ".texto-login"
                );


            texto.textContent =
                "Verificando...";

        }
    );


</script>

</body>

</html>
