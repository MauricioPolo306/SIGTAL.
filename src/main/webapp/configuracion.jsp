<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.sigtal.modelo.Usuario" %>

<%
    List<Usuario> usuarios =
            (List<Usuario>) request.getAttribute("usuarios");

    if (usuarios == null) {
        usuarios = new java.util.ArrayList<>();
    }

    String nombreUsuario =
            (String) session.getAttribute("nombreUsuario");

    String rol =
            (String) session.getAttribute("rol");

    Object idSesion =
            session.getAttribute("idUsuario");

    if (nombreUsuario == null || nombreUsuario.trim().isEmpty()) {
        nombreUsuario = "Administrador";
    }

    if (rol == null || rol.trim().isEmpty()) {
        rol = "ADMIN";
    }
%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Configuración | SIGTAL</title>


    <!-- ICONOS -->

    <script src="https://unpkg.com/lucide@latest"></script>


    <style>

        /* =====================================================
           VARIABLES
           ===================================================== */

        :root {

            --primary: #2563eb;
            --primary-dark: #1d4ed8;

            --success: #16a34a;
            --warning: #d97706;
            --danger: #dc2626;

            --dark: #0f172a;
            --text: #334155;
            --muted: #64748b;

            --background: #f1f5f9;
            --white: #ffffff;

            --border: #e2e8f0;

            --shadow:
                0 4px 15px rgba(15,23,42,.07);

            --radius: 16px;
        }


        /* =====================================================
           RESET
           ===================================================== */

        * {

            box-sizing: border-box;

            margin: 0;

            padding: 0;
        }


        body {

            font-family:
                "Segoe UI",
                Arial,
                sans-serif;

            background:
                var(--background);

            color:
                var(--text);

            min-height: 100vh;
        }


        a {

            text-decoration: none;

            color: inherit;
        }


        button,
        input,
        select {

            font-family: inherit;
        }


        /* =====================================================
           LAYOUT
           ===================================================== */

        .layout {

            display: flex;

            min-height: 100vh;
        }


        /* =====================================================
           SIDEBAR
           ===================================================== */

        .sidebar {

            width: 250px;

            background:
                linear-gradient(
                    180deg,
                    #0f172a,
                    #172554
                );

            color: white;

            position: fixed;

            left: 0;

            top: 0;

            bottom: 0;

            display: flex;

            flex-direction: column;

            z-index: 1000;
        }


        .logo {

            height: 80px;

            display: flex;

            align-items: center;

            gap: 12px;

            padding: 0 22px;

            border-bottom:
                1px solid rgba(255,255,255,.08);
        }


        .logo-icon {

            width: 42px;

            height: 42px;

            border-radius: 12px;

            background:
                var(--primary);

            display: flex;

            align-items: center;

            justify-content: center;
        }


        .logo-icon svg {

            width: 22px;
        }


        .logo-text strong {

            display: block;

            font-size: 20px;
        }


        .logo-text span {

            display: block;

            font-size: 11px;

            color:
                #94a3b8;
        }


        .menu {

            flex: 1;

            padding: 20px 12px;
        }


        .menu-title {

            font-size: 10px;

            color: #64748b;

            text-transform: uppercase;

            letter-spacing: 1px;

            padding: 10px 14px;
        }


        .menu a {

            display: flex;

            align-items: center;

            gap: 12px;

            padding: 12px 14px;

            margin-bottom: 4px;

            border-radius: 10px;

            color: #cbd5e1;

            font-size: 14px;

            transition: .2s;
        }


        .menu a:hover {

            background:
                rgba(255,255,255,.08);

            color: white;
        }


        .menu a.active {

            background:
                var(--primary);

            color: white;
        }


        .menu svg {

            width: 18px;

            height: 18px;
        }


        .sidebar-footer {

            padding: 16px;

            border-top:
                1px solid rgba(255,255,255,.08);
        }


        .user-mini {

            display: flex;

            align-items: center;

            gap: 10px;

            margin-bottom: 12px;
        }


        .avatar {

            width: 38px;

            height: 38px;

            border-radius: 50%;

            background:
                var(--primary);

            display: flex;

            align-items: center;

            justify-content: center;

            font-weight: 700;
        }


        .user-mini strong {

            display: block;

            font-size: 13px;
        }


        .user-mini span {

            font-size: 11px;

            color: #94a3b8;
        }


        .logout {

            width: 100%;

            border: none;

            padding: 10px;

            border-radius: 9px;

            background:
                rgba(220,38,38,.12);

            color: #fca5a5;

            cursor: pointer;

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 8px;
        }


        .logout:hover {

            background:
                rgba(220,38,38,.25);

            color: white;
        }


        /* =====================================================
           MAIN
           ===================================================== */

        .main {

            margin-left: 250px;

            width:
                calc(100% - 250px);

            min-height: 100vh;
        }


        /* =====================================================
           TOPBAR
           ===================================================== */

        .topbar {

            height: 80px;

            background:
                white;

            border-bottom:
                1px solid var(--border);

            padding: 0 30px;

            display: flex;

            align-items: center;

            justify-content: space-between;
        }


        .topbar h1 {

            color:
                var(--dark);

            font-size: 24px;

            margin-bottom: 3px;
        }


        .topbar p {

            color:
                var(--muted);

            font-size: 13px;
        }


        .top-user {

            display: flex;

            align-items: center;

            gap: 10px;
        }


        .top-user-icon {

            width: 42px;

            height: 42px;

            border-radius: 50%;

            background:
                #dbeafe;

            color:
                var(--primary);

            display: flex;

            align-items: center;

            justify-content: center;
        }


        .top-user strong {

            color:
                var(--dark);

            font-size: 13px;
        }


        .top-user small {

            color:
                var(--muted);

            font-size: 11px;
        }


        /* =====================================================
           CONTENT
           ===================================================== */

        .content {

            padding: 30px;
        }


        /* =====================================================
           WELCOME
           ===================================================== */

        .welcome {

            background:
                linear-gradient(
                    120deg,
                    #1d4ed8,
                    #2563eb,
                    #3b82f6
                );

            color: white;

            border-radius: 18px;

            padding: 25px 28px;

            margin-bottom: 22px;

            box-shadow:
                0 10px 25px
                rgba(37,99,235,.16);
        }


        .welcome h2 {

            font-size: 22px;

            margin-bottom: 6px;
        }


        .welcome p {

            color: #dbeafe;

            font-size: 13px;
        }


        /* =====================================================
           SECTION GRID
           ===================================================== */

        .grid {

            display: grid;

            grid-template-columns:
                1fr 2fr;

            gap: 20px;

            margin-bottom: 20px;
        }


        .panel {

            background:
                white;

            border:
                1px solid var(--border);

            border-radius:
                var(--radius);

            box-shadow:
                var(--shadow);

            overflow:
                hidden;
        }


        .panel-header {

            padding: 18px 20px;

            border-bottom:
                1px solid var(--border);

            display: flex;

            align-items: center;

            justify-content: space-between;
        }


        .panel-header h2 {

            color:
                var(--dark);

            font-size: 16px;

            display: flex;

            align-items: center;

            gap: 8px;
        }


        .panel-header h2 svg {

            width: 18px;

            color:
                var(--primary);
        }


        .panel-header span {

            font-size: 11px;

            color:
                var(--muted);
        }


        .panel-body {

            padding: 20px;
        }


        /* =====================================================
           FORMULARIO
           ===================================================== */

        .form-group {

            margin-bottom: 15px;
        }


        .form-group label {

            display: block;

            font-size: 12px;

            font-weight: 600;

            color:
                #475569;

            margin-bottom: 6px;
        }


        .form-group input,
        .form-group select {

            width: 100%;

            padding: 10px 12px;

            border:
                1px solid #cbd5e1;

            border-radius: 9px;

            outline: none;

            background: white;

            font-size: 13px;
        }


        .form-group input:focus,
        .form-group select:focus {

            border-color:
                var(--primary);

            box-shadow:
                0 0 0 3px #dbeafe;
        }


        .password-wrapper {

            position: relative;
        }


        .password-wrapper input {

            padding-right: 42px;
        }


        .password-toggle {

            position: absolute;

            right: 10px;

            top: 50%;

            transform:
                translateY(-50%);

            border: none;

            background: none;

            cursor: pointer;

            color:
                var(--muted);
        }


        .password-toggle svg {

            width: 17px;
        }


        .btn {

            width: 100%;

            border: none;

            padding: 11px 16px;

            border-radius: 9px;

            background:
                var(--primary);

            color: white;

            cursor: pointer;

            font-weight: 600;

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            transition: .2s;
        }


        .btn:hover {

            background:
                var(--primary-dark);
        }


        .btn-secondary {

            background:
                #e2e8f0;

            color:
                #334155;
        }


        .btn-secondary:hover {

            background:
                #cbd5e1;
        }


        /* =====================================================
           TABLA
           ===================================================== */

        .table-wrapper {

            overflow-x: auto;
        }


        table {

            width: 100%;

            border-collapse: collapse;
        }


        th {

            padding: 12px 15px;

            background:
                #f8fafc;

            color:
                #64748b;

            text-align: left;

            font-size: 10px;

            text-transform: uppercase;

            letter-spacing: .4px;

            white-space: nowrap;
        }


        td {

            padding: 13px 15px;

            border-top:
                1px solid var(--border);

            font-size: 12px;

            white-space: nowrap;
        }


        tbody tr:hover {

            background:
                #f8fafc;
        }


        .user-name {

            font-weight: 700;

            color:
                var(--dark);
        }


        .user-login {

            color:
                var(--primary);

            font-weight: 600;
        }


        /* =====================================================
           BADGES
           ===================================================== */

        .badge {

            display: inline-flex;

            padding: 5px 9px;

            border-radius: 20px;

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;
        }


        .badge-active {

            background:
                #dcfce7;

            color:
                #15803d;
        }


        .badge-inactive {

            background:
                #fee2e2;

            color:
                #b91c1c;
        }


        .badge-admin {

            background:
                #dbeafe;

            color:
                #1d4ed8;
        }

        .badge-tecnico {

            background:
                #ffedd5;

            color:
                #c2410c;
        }


        /* =====================================================
           ACTIONS
           ===================================================== */

        .actions {

            display: flex;

            gap: 6px;
        }


        .action {

            width: 32px;

            height: 32px;

            border: none;

            border-radius: 8px;

            display: flex;

            align-items: center;

            justify-content: center;

            cursor: pointer;
        }


        .action svg {

            width: 15px;

            height: 15px;
        }


        .action-edit {

            background:
                #dbeafe;

            color:
                #2563eb;
        }


        .action-password {

            background:
                #f3e8ff;

            color:
                #9333ea;
        }


        .action-on {

            background:
                #fee2e2;

            color:
                #dc2626;
        }


        .action-off {

            background:
                #dcfce7;

            color:
                #16a34a;
        }


        /* =====================================================
           INFO
           ===================================================== */

        .info-grid {

            display: grid;

            grid-template-columns:
                repeat(2, 1fr);

            gap: 12px;
        }


        .info-box {

            padding: 14px;

            border:
                1px solid var(--border);

            border-radius: 10px;

            background:
                #f8fafc;
        }


        .info-box span {

            display: block;

            color:
                var(--muted);

            font-size: 10px;

            margin-bottom: 4px;
        }


        .info-box strong {

            color:
                var(--dark);

            font-size: 13px;
        }


        /* =====================================================
           MENSAJES
           ===================================================== */

        .message {

            padding: 12px 15px;

            border-radius: 9px;

            margin-bottom: 20px;

            font-size: 13px;

            display: flex;

            align-items: center;

            gap: 8px;
        }


        .message-success {

            background:
                #dcfce7;

            color:
                #166534;

            border:
                1px solid #bbf7d0;
        }


        .message-error {

            background:
                #fee2e2;

            color:
                #991b1b;

            border:
                1px solid #fecaca;
        }


        /* =====================================================
           FOOTER
           ===================================================== */

        .footer {

            text-align: center;

            color:
                var(--muted);

            font-size: 11px;

            padding: 5px 0 20px;
        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media(max-width:1100px) {

            .grid {

                grid-template-columns: 1fr;
            }

        }


        @media(max-width:700px) {

            .sidebar {

                position: static;

                width: 100%;

            }


            .layout {

                flex-direction: column;
            }


            .main {

                margin-left: 0;

                width: 100%;
            }


            .menu {

                display: none;
            }


            .sidebar-footer {

                display: none;
            }


            .content {

                padding: 15px;
            }


            .topbar {

                padding: 0 15px;
            }


            .info-grid {

                grid-template-columns: 1fr;
            }

        }

    </style>

</head>


<body>


<div class="layout">


    <!-- =====================================================
         SIDEBAR
         ===================================================== -->

    <aside class="sidebar">


        <div class="logo">

            <div class="logo-icon">

                <i data-lucide="wrench"></i>

            </div>

            <div class="logo-text">

                <strong>SIGTAL</strong>

                <span>Taller Automotriz</span>

            </div>

        </div>


        <nav class="menu">


            <div class="menu-title">
                Principal
            </div>


            <a href="<%=request.getContextPath()%>/Inicio">

                <i data-lucide="layout-Inicio"></i>

                Inicio

            </a>


            <a href="<%=request.getContextPath()%>/clientes">

                <i data-lucide="users"></i>

                Clientes y Vehículos

            </a>


            <a href="<%=request.getContextPath()%>/inventario">

                <i data-lucide="package"></i>

                Inventario

            </a>


            <a href="<%=request.getContextPath()%>/facturacion">

                <i data-lucide="receipt"></i>

                Facturación

            </a>


            <div class="menu-title">

                Gestión

            </div>


            <a href="<%=request.getContextPath()%>/reportes">

                <i data-lucide="bar-chart-3"></i>

                Reportes

            </a>


            <a href="<%=request.getContextPath()%>/configuracion"
               class="active">

                <i data-lucide="settings"></i>

                Configuración

            </a>

        </nav>


        <div class="sidebar-footer">


            <div class="user-mini">


                <div class="avatar">

                    <%=nombreUsuario.substring(0,1).toUpperCase()%>

                </div>


                <div>

                    <strong>
                        <%=nombreUsuario%>
                    </strong>

                    <span>
                        <%=rol%>
                    </span>

                </div>

            </div>


            <form method="post"
                  action="<%=request.getContextPath()%>/logout">

                <button class="logout"
                        type="submit">

                    <i data-lucide="log-out"></i>

                    Cerrar sesión

                </button>

            </form>

        </div>

    </aside>



    <!-- =====================================================
         MAIN
         ===================================================== -->

    <main class="main">


        <!-- TOPBAR -->

        <header class="topbar">


            <div>

                <h1>
                    Configuración
                </h1>

                <p>
                    Administración del sistema SIGTAL
                </p>

            </div>


            <div class="top-user">

                <div class="top-user-icon">

                    <i data-lucide="user"></i>

                </div>


                <div>

                    <strong>
                        <%=nombreUsuario%>
                    </strong>

                    <br>

                    <small>
                        <%=rol%>
                    </small>

                </div>

            </div>

        </header>



        <!-- CONTENIDO -->

        <section class="content">


            <!-- =================================================
                 BIENVENIDA
                 ================================================= -->

            <div class="welcome">

                <h2>
                    Administración de SIGTAL ⚙️
                </h2>

                <p>
                    Gestiona usuarios, roles y parámetros
                    generales del sistema.
                </p>

            </div>



            <!-- =================================================
                 MENSAJES
                 ================================================= -->

            <%

                String mensaje =
                        request.getParameter("mensaje");

                String error =
                        request.getParameter("error");


                if ("usuario_creado".equals(mensaje)) {

            %>

                <div class="message message-success">

                    <i data-lucide="circle-check"></i>

                    Usuario creado correctamente.

                </div>

            <%

                } else if ("usuario_actualizado".equals(mensaje)) {

            %>

                <div class="message message-success">

                    <i data-lucide="circle-check"></i>

                    Usuario actualizado correctamente.

                </div>

            <%

                } else if ("estado_actualizado".equals(mensaje)) {

            %>

                <div class="message message-success">

                    <i data-lucide="circle-check"></i>

                    Estado del usuario actualizado.

                </div>

            <%

                } else if ("password_actualizada".equals(mensaje)) {

            %>

                <div class="message message-success">

                    <i data-lucide="circle-check"></i>

                    Contraseña actualizada correctamente.

                </div>

            <%

                } else if ("propia_cuenta".equals(error)) {

            %>

                <div class="message message-error">

                    <i data-lucide="triangle-alert"></i>

                    No puedes desactivar tu propia cuenta.

                </div>

            <%

                } else if ("usuario_no_creado".equals(error)) {

            %>

                <div class="message message-error">

                    <i data-lucide="triangle-alert"></i>

                    No fue posible crear el usuario.
                    Verifica que el nombre de usuario
                    no esté repetido.

                </div>

            <%

                } else if ("usuario_no_actualizado".equals(error)) {

            %>

                <div class="message message-error">

                    <i data-lucide="triangle-alert"></i>

                    No fue posible actualizar el usuario.

                </div>

            <%

                } else if ("estado_no_actualizado".equals(error)) {

            %>

                <div class="message message-error">

                    <i data-lucide="triangle-alert"></i>

                    No fue posible cambiar el estado.

                </div>

            <%

                } else if ("password_vacia".equals(error)) {

            %>

                <div class="message message-error">

                    <i data-lucide="triangle-alert"></i>

                    La contraseña no puede estar vacía.

                </div>

            <%

                } else if ("password_no_actualizada".equals(error)) {

            %>

                <div class="message message-error">

                    <i data-lucide="triangle-alert"></i>

                    No fue posible actualizar la contraseña.

                </div>

            <% } %>



            <!-- =================================================
                 CREAR USUARIO + INFORMACIÓN
                 ================================================= -->

            <div class="grid">


                <!-- CREAR USUARIO -->

                <div class="panel">


                    <div class="panel-header">

                        <h2>

                            <i data-lucide="user-plus"></i>

                            Nuevo usuario

                        </h2>

                        <span>
                            Administración
                        </span>

                    </div>


                    <div class="panel-body">


                        <form method="post"
                              action="<%=request.getContextPath()%>/configuracion">


                            <input type="hidden"
                                   name="accion"
                                   value="crear">


                            <div class="form-group">

                                <label>
                                    Nombre completo
                                </label>

                                <input
                                    type="text"
                                    name="nombre"
                                    placeholder="Ej. Juan Pérez"
                                    required>

                            </div>


                            <div class="form-group">

                                <label>
                                    Usuario
                                </label>

                                <input
                                    type="text"
                                    name="usuario"
                                    placeholder="Ej. jperez"
                                    required>

                            </div>


                            <div class="form-group">

                                <label>
                                    Contraseña
                                </label>


                                <div class="password-wrapper">

                                    <input
                                        type="password"
                                        id="passwordNuevo"
                                        name="password"
                                        placeholder="Contraseña"
                                        required>


                                    <button
                                        type="button"
                                        class="password-toggle"
                                        onclick="togglePassword(
                                            'passwordNuevo',
                                            this
                                        )">

                                        <i data-lucide="eye"></i>

                                    </button>

                                </div>

                            </div>


                            <div class="form-group">

                                <label>
                                    Rol
                                </label>

                                <select name="rol"
                                        required>

                                    <option value="ADMIN">
                                        Administrador
                                    </option>

                                    <option value="TECNICO">
                                        Técnico
                                    </option>

                                </select>

                            </div>


                            <div class="form-group">

                                <label>
                                    Estado
                                </label>

                                <select name="estado">

                                    <option value="ACTIVO">
                                        Activo
                                    </option>

                                    <option value="INACTIVO">
                                        Inactivo
                                    </option>

                                </select>

                            </div>


                            <button
                                type="submit"
                                class="btn">

                                <i data-lucide="user-plus"></i>

                                Crear usuario

                            </button>

                        </form>

                    </div>

                </div>



                <!-- INFORMACIÓN DEL SISTEMA -->

                <div class="panel">


                    <div class="panel-header">

                        <h2>

                            <i data-lucide="building-2"></i>

                            Información del sistema

                        </h2>

                        <span>
                            SIGTAL
                        </span>

                    </div>


                    <div class="panel-body">


                        <div class="info-grid">


                            <div class="info-box">

                                <span>
                                    Sistema
                                </span>

                                <strong>
                                    SIGTAL
                                </strong>

                            </div>


                            <div class="info-box">

                                <span>
                                    Taller
                                </span>

                                <strong>
                                    TALLER LONDOÑO
                                </strong>

                            </div>


                            <div class="info-box">

                                <span>
                                    Descripción
                                </span>

                                <strong>
                                    Sistema Integral de Gestión
                                </strong>

                            </div>


                            <div class="info-box">

                                <span>
                                    Ubicación
                                </span>

                                <strong>
                                    Barranquilla, Atlántico
                                </strong>

                            </div>


                            <div class="info-box">

                                <span>
                                    Plataforma
                                </span>

                                <strong>
                                    Java Web
                                </strong>

                            </div>


                            <div class="info-box">

                                <span>
                                    Base de datos
                                </span>

                                <strong>
                                    MariaDB
                                </strong>

                            </div>


                        </div>

                    </div>

                </div>

            </div>



            <!-- =================================================
                 USUARIOS
                 ================================================= -->

            <div class="panel">


                <div class="panel-header">

                    <h2>

                        <i data-lucide="users"></i>

                        Usuarios del sistema

                    </h2>

                    <span>

                        <%=usuarios.size()%>
                        usuario(s)

                    </span>

                </div>


                <div class="table-wrapper">


                    <table>


                        <thead>

                        <tr>

                            <th>
                                ID
                            </th>

                            <th>
                                Nombre
                            </th>

                            <th>
                                Usuario
                            </th>

                            <th>
                                Rol
                            </th>

                            <th>
                                Estado
                            </th>

                            <th>
                                Acciones
                            </th>

                        </tr>

                        </thead>


                        <tbody>


                        <% for (Usuario u : usuarios) { %>


                        <tr>


                            <td>

                                <strong>
                                    <%=u.getIdUsuario()%>
                                </strong>

                            </td>


                            <td>

                                <span class="user-name">

                                    <%=u.getNombre()%>

                                </span>

                            </td>


                            <td>

                                <span class="user-login">

                                    @<%=u.getUsuario()%>

                                </span>

                            </td>


                            <td>


                                <%

                                    String claseRol =
                                            "badge-admin";

                                    if ("TECNICO".equalsIgnoreCase(
                                            u.getRol()
                                    )) {

                                        claseRol =
                                                "badge-tecnico";
                                    }

                                %>


                                <span class="badge <%=claseRol%>">

                                    <%=u.getRol()%>

                                </span>

                            </td>


                            <td>


                                <%

                                    boolean activo =
                                            "ACTIVO".equalsIgnoreCase(
                                                    u.getEstado()
                                            );

                                %>


                                <span class="badge
                                    <%=activo
                                        ? "badge-active"
                                        : "badge-inactive"%>">

                                    <%=u.getEstado()%>

                                </span>

                            </td>


                            <td>


                                <div class="actions">


                                    <!-- EDITAR -->

                                    <button
                                        type="button"
                                        class="action action-edit"
                                        title="Editar usuario"
                                        onclick="editarUsuario(
                                            '<%=u.getIdUsuario()%>',
                                            '<%=u.getNombre()%>',
                                            '<%=u.getUsuario()%>',
                                            '<%=u.getRol()%>',
                                            '<%=u.getEstado()%>'
                                        )">

                                        <i data-lucide="pencil"></i>

                                    </button>


                                    <!-- CONTRASEÑA -->

                                    <button
                                        type="button"
                                        class="action action-password"
                                        title="Cambiar contraseña"
                                        onclick="cambiarPassword(
                                            '<%=u.getIdUsuario()%>',
                                            '<%=u.getNombre()%>'
                                        )">

                                        <i data-lucide="key-round"></i>

                                    </button>


                                    <!-- ESTADO -->

                                    <form
                                        method="post"
                                        action="<%=request.getContextPath()%>/configuracion"
                                        style="display:inline;">

                                        <input
                                            type="hidden"
                                            name="accion"
                                            value="estado">


                                        <input
                                            type="hidden"
                                            name="idUsuario"
                                            value="<%=u.getIdUsuario()%>">


                                        <input
                                            type="hidden"
                                            name="estado"
                                            value="<%=activo
                                                ? "INACTIVO"
                                                : "ACTIVO"%>">


                                        <button
                                            type="submit"
                                            class="action
                                                <%=activo
                                                    ? "action-on"
                                                    : "action-off"%>"
                                            title="<%=activo
                                                ? "Desactivar"
                                                : "Activar"%>">

                                            <i data-lucide="<%=activo
                                                ? "user-x"
                                                : "user-check"%>">
                                            </i>

                                        </button>

                                    </form>


                                </div>

                            </td>

                        </tr>


                        <% } %>


                        <% if (usuarios.isEmpty()) { %>


                        <tr>

                            <td colspan="6"
                                style="text-align:center;padding:35px;">

                                No hay usuarios registrados.

                            </td>

                        </tr>


                        <% } %>


                        </tbody>

                    </table>

                </div>

            </div>



            <!-- =================================================
                 PIE
                 ================================================= -->

            <div class="footer">

                SIGTAL — Sistema Integral de Gestión para
                Taller Automotriz

                <br>

                <strong>
                    TALLER LONDOÑO
                </strong>

                · Barranquilla, Atlántico, Colombia

            </div>


        </section>

    </main>

</div>



<!-- =========================================================
     MODAL EDITAR
     ========================================================= -->

<div id="modalEditar"
     class="modal-overlay"
     style="display:none;">


    <div class="modal">


        <div class="modal-header">

            <h2>
                Editar usuario
            </h2>

            <button
                type="button"
                onclick="cerrarModal('modalEditar')">

                <i data-lucide="x"></i>

            </button>

        </div>


        <form method="post"
              action="<%=request.getContextPath()%>/configuracion">


            <input
                type="hidden"
                name="accion"
                value="actualizar">


            <input
                type="hidden"
                id="editarId"
                name="idUsuario">


            <div class="modal-body">


                <div class="form-group">

                    <label>
                        Nombre
                    </label>

                    <input
                        type="text"
                        id="editarNombre"
                        name="nombre"
                        required>

                </div>


                <div class="form-group">

                    <label>
                        Usuario
                    </label>

                    <input
                        type="text"
                        id="editarUsuario"
                        name="usuario"
                        required>

                </div>


                <div class="form-group">

                    <label>
                        Rol
                    </label>

                    <select
                        id="editarRol"
                        name="rol">

                        <option value="ADMIN">
                            Administrador
                        </option>

                        <option value="TECNICO">
                            Técnico
                        </option>

                    </select>

                </div>


                <div class="form-group">

                    <label>
                        Estado
                    </label>

                    <select
                        id="editarEstado"
                        name="estado">

                        <option value="ACTIVO">
                            Activo
                        </option>

                        <option value="INACTIVO">
                            Inactivo
                        </option>

                    </select>

                </div>

            </div>


            <div class="modal-footer">

                <button
                    type="button"
                    class="btn btn-secondary"
                    onclick="cerrarModal('modalEditar')">

                    Cancelar

                </button>


                <button
                    type="submit"
                    class="btn">

                    <i data-lucide="save"></i>

                    Guardar cambios

                </button>

            </div>

        </form>

    </div>

</div>



<!-- =========================================================
     MODAL CONTRASEÑA
     ========================================================= -->

<div id="modalPassword"
     class="modal-overlay"
     style="display:none;">


    <div class="modal">


        <div class="modal-header">

            <h2>
                Cambiar contraseña
            </h2>

            <button
                type="button"
                onclick="cerrarModal('modalPassword')">

                <i data-lucide="x"></i>

            </button>

        </div>


        <form method="post"
              action="<%=request.getContextPath()%>/configuracion">


            <input
                type="hidden"
                name="accion"
                value="password">


            <input
                type="hidden"
                id="passwordId"
                name="idUsuario">


            <div class="modal-body">


                <p id="passwordUsuario"
                   style="
                       margin-bottom:15px;
                       color:#64748b;
                       font-size:13px;
                   ">
                </p>


                <div class="form-group">

                    <label>
                        Nueva contraseña
                    </label>


                    <div class="password-wrapper">

                        <input
                            type="password"
                            id="passwordCambiar"
                            name="password"
                            minlength="4"
                            required>


                        <button
                            type="button"
                            class="password-toggle"
                            onclick="togglePassword(
                                'passwordCambiar',
                                this
                            )">

                            <i data-lucide="eye"></i>

                        </button>

                    </div>

                </div>

            </div>


            <div class="modal-footer">

                <button
                    type="button"
                    class="btn btn-secondary"
                    onclick="cerrarModal('modalPassword')">

                    Cancelar

                </button>


                <button
                    type="submit"
                    class="btn">

                    <i data-lucide="key-round"></i>

                    Cambiar contraseña

                </button>

            </div>

        </form>

    </div>

</div>



<style>

/* =========================================================
   MODALES
   ========================================================= */

.modal-overlay {

    position: fixed;

    inset: 0;

    background:
        rgba(15,23,42,.55);

    display: flex;

    align-items: center;

    justify-content: center;

    z-index: 5000;

    padding: 20px;
}


.modal {

    background: white;

    width: 100%;

    max-width: 500px;

    border-radius: 16px;

    box-shadow:
        0 25px 60px
        rgba(15,23,42,.25);

    overflow: hidden;

    animation:
        modalIn .2s ease;
}


@keyframes modalIn {

    from {

        opacity: 0;

        transform:
            translateY(15px)
            scale(.98);
    }

    to {

        opacity: 1;

        transform:
            translateY(0)
            scale(1);
    }
}


.modal-header {

    padding: 18px 20px;

    border-bottom:
        1px solid #e2e8f0;

    display: flex;

    align-items: center;

    justify-content: space-between;
}


.modal-header h2 {

    color: #0f172a;

    font-size: 17px;
}


.modal-header button {

    border: none;

    background: none;

    cursor: pointer;

    color: #64748b;
}


.modal-body {

    padding: 20px;
}


.modal-footer {

    padding: 15px 20px;

    border-top:
        1px solid #e2e8f0;

    display: flex;

    justify-content: flex-end;

    gap: 10px;
}


.modal-footer .btn {

    width: auto;

    min-width: 130px;
}

</style>



<script>

/* =========================================================
   ICONOS
   ========================================================= */

lucide.createIcons();


/* =========================================================
   ESCAPAR TEXTO PARA JAVASCRIPT
   ========================================================= */

function escaparTexto(texto) {

    if (texto === null || texto === undefined) {

        return "";

    }

    return String(texto)
        .replace(/\\/g, "\\\\")
        .replace(/'/g, "\\'")
        .replace(/"/g, "&quot;")
        .replace(/\r?\n/g, " ");
}


/* =========================================================
   EDITAR USUARIO
   ========================================================= */

function editarUsuario(
    id,
    nombre,
    usuario,
    rol,
    estado
) {

    document.getElementById("editarId").value =
        id;

    document.getElementById("editarNombre").value =
        nombre;

    document.getElementById("editarUsuario").value =
        usuario;

    document.getElementById("editarRol").value =
        rol;

    document.getElementById("editarEstado").value =
        estado;


    document.getElementById("modalEditar").style.display =
        "flex";


    lucide.createIcons();
}


/* =========================================================
   CAMBIAR CONTRASEÑA
   ========================================================= */

function cambiarPassword(
    id,
    nombre
) {

    document.getElementById("passwordId").value =
        id;


    document.getElementById("passwordUsuario").innerText =
        "Usuario: " + nombre;


    document.getElementById("passwordCambiar").value =
        "";


    document.getElementById("modalPassword").style.display =
        "flex";


    lucide.createIcons();
}


/* =========================================================
   CERRAR MODAL
   ========================================================= */

function cerrarModal(id) {

    document.getElementById(id).style.display =
        "none";
}


/* =========================================================
   MOSTRAR / OCULTAR CONTRASEÑA
   ========================================================= */

function togglePassword(
    inputId,
    boton
) {

    const input =
        document.getElementById(inputId);


    if (input.type === "password") {

        input.type = "text";

        boton.innerHTML =
            '<i data-lucide="eye-off"></i>';

    } else {

        input.type = "password";

        boton.innerHTML =
            '<i data-lucide="eye"></i>';
    }


    lucide.createIcons();
}


/* =========================================================
   CERRAR MODAL AL HACER CLICK FUERA
   ========================================================= */

document.addEventListener(
    "click",
    function(event) {

        const editar =
            document.getElementById(
                "modalEditar"
            );

        const password =
            document.getElementById(
                "modalPassword"
            );


        if (event.target === editar) {

            cerrarModal(
                "modalEditar"
            );
        }


        if (event.target === password) {

            cerrarModal(
                "modalPassword"
            );
        }

    }
);

</script>


</body>

</html>