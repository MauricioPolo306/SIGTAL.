<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Date" %>

<%
    /* =========================================================
       DATOS RECIBIDOS DESDE DashboardServlet
       ========================================================= */

    Integer totalClientes = (Integer) request.getAttribute("totalClientes");
    Integer totalVehiculos = (Integer) request.getAttribute("totalVehiculos");
    Integer totalProductos = (Integer) request.getAttribute("totalProductos");
    Integer totalFacturas = (Integer) request.getAttribute("totalFacturas");
    Integer productosStockBajo = (Integer) request.getAttribute("productosStockBajo");

    Double totalVentas = (Double) request.getAttribute("totalVentas");

    List<Map<String, Object>> ventasPorMes =
            (List<Map<String, Object>>) request.getAttribute("ventasPorMes");

    List<Map<String, Object>> ultimasFacturas =
            (List<Map<String, Object>>) request.getAttribute("ultimasFacturas");

    List<Map<String, Object>> detalleStockBajo =
            (List<Map<String, Object>>) request.getAttribute("detalleStockBajo");


    /* =========================================================
       VALORES POR DEFECTO
       ========================================================= */

    if (totalClientes == null) totalClientes = 0;
    if (totalVehiculos == null) totalVehiculos = 0;
    if (totalProductos == null) totalProductos = 0;
    if (totalFacturas == null) totalFacturas = 0;
    if (productosStockBajo == null) productosStockBajo = 0;
    if (totalVentas == null) totalVentas = 0.0;

    if (ventasPorMes == null) ventasPorMes = new java.util.ArrayList<>();
    if (ultimasFacturas == null) ultimasFacturas = new java.util.ArrayList<>();
    if (detalleStockBajo == null) detalleStockBajo = new java.util.ArrayList<>();


    /* =========================================================
       USUARIO DE SESIÓN
       ========================================================= */

    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");

    if (nombreUsuario == null || nombreUsuario.trim().isEmpty()) {
        nombreUsuario = "Administrador";
    }

    if (usuario == null || usuario.trim().isEmpty()) {
        usuario = "admin";
    }

    if (rol == null || rol.trim().isEmpty()) {
        rol = "ADMIN";
    }


    /* =========================================================
       FORMATO DE MONEDA
       ========================================================= */

    NumberFormat formatoMoneda =
            NumberFormat.getCurrencyInstance(new Locale("es", "CO"));

    formatoMoneda.setMaximumFractionDigits(0);


    /* =========================================================
       FORMATO DE FECHA
       ========================================================= */

    SimpleDateFormat formatoFecha =
            new SimpleDateFormat("dd/MM/yyyy");


    /* =========================================================
       DATOS PARA EL GRÁFICO
       ========================================================= */

    StringBuilder etiquetasGrafico = new StringBuilder();
    StringBuilder valoresGrafico = new StringBuilder();

    for (Map<String, Object> venta : ventasPorMes) {

        String mes = String.valueOf(venta.get("mes"));
        Object total = venta.get("total");

        if (etiquetasGrafico.length() > 0) {
            etiquetasGrafico.append(",");
            valoresGrafico.append(",");
        }

        etiquetasGrafico.append("'")
                .append(mes.replace("'", "\\'"))
                .append("'");

        valoresGrafico.append(
                total == null ? "0" : total.toString()
        );
    }
%>


<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Dashboard | SIGTAL</title>


    <!-- =====================================================
         ICONOS
         ====================================================== -->

    <script src="https://unpkg.com/lucide@latest"></script>


    <!-- =====================================================
         CHART.JS
         ====================================================== -->

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


    <style>

        /* =====================================================
           VARIABLES
           ====================================================== */

        :root {

            --primary: #2563eb;
            --primary-dark: #1d4ed8;

            --success: #16a34a;
            --warning: #d97706;
            --danger: #dc2626;

            --dark: #0f172a;
            --dark-2: #1e293b;

            --text: #334155;
            --muted: #64748b;

            --background: #f1f5f9;
            --white: #ffffff;

            --border: #e2e8f0;

            --shadow:
                0 4px 15px rgba(15, 23, 42, 0.07);

            --radius: 16px;
        }


        /* =====================================================
           RESET
           ====================================================== */

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

            background: var(--background);

            color: var(--text);

            min-height: 100vh;
        }


        a {
            text-decoration: none;
            color: inherit;
        }


        button {
            font-family: inherit;
        }


        /* =====================================================
           LAYOUT
           ====================================================== */

        .layout {

            display: flex;

            min-height: 100vh;
        }


        /* =====================================================
           SIDEBAR
           ====================================================== */

        .sidebar {

            width: 250px;

            background:
                linear-gradient(
                    180deg,
                    #0f172a 0%,
                    #172554 100%
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

            background: var(--primary);

            display: flex;

            align-items: center;

            justify-content: center;
        }


        .logo-text strong {

            display: block;

            font-size: 20px;

            letter-spacing: .5px;
        }


        .logo-text span {

            font-size: 11px;

            color: #94a3b8;
        }


        .menu {

            padding: 20px 12px;

            flex: 1;
        }


        .menu-title {

            color: #64748b;

            font-size: 11px;

            text-transform: uppercase;

            letter-spacing: 1px;

            padding: 10px 14px;

            margin-bottom: 5px;
        }


        .menu a {

            display: flex;

            align-items: center;

            gap: 12px;

            padding: 12px 14px;

            margin-bottom: 5px;

            border-radius: 10px;

            color: #cbd5e1;

            font-size: 14px;

            transition: .2s;
        }


        .menu a:hover {

            background:
                rgba(255,255,255,.08);

            color: white;

            transform: translateX(2px);
        }


        .menu a.active {

            background: var(--primary);

            color: white;

            box-shadow:
                0 5px 15px
                rgba(37,99,235,.25);
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

            padding: 10px;

            margin-bottom: 10px;
        }


        .avatar {

            width: 38px;
            height: 38px;

            border-radius: 50%;

            background: var(--primary);

            display: flex;

            align-items: center;

            justify-content: center;

            font-weight: 700;
        }


        .user-info {

            overflow: hidden;
        }


        .user-info strong {

            display: block;

            font-size: 13px;

            white-space: nowrap;

            overflow: hidden;

            text-overflow: ellipsis;
        }


        .user-info span {

            color: #94a3b8;

            font-size: 11px;
        }


        .logout {

            width: 100%;

            border: none;

            background:
                rgba(220,38,38,.12);

            color: #fca5a5;

            padding: 10px;

            border-radius: 9px;

            cursor: pointer;

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            transition: .2s;
        }


        .logout:hover {

            background:
                rgba(220,38,38,.25);

            color: white;
        }


        /* =====================================================
           MAIN
           ====================================================== */

        .main {

            margin-left: 250px;

            width: calc(100% - 250px);

            min-height: 100vh;
        }


        /* =====================================================
           TOPBAR
           ====================================================== */

        .topbar {

            height: 80px;

            background: white;

            border-bottom:
                1px solid var(--border);

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding: 0 30px;

            position: sticky;

            top: 0;

            z-index: 500;
        }


        .page-title h1 {

            font-size: 24px;

            color: var(--dark);

            margin-bottom: 3px;
        }


        .page-title p {

            font-size: 13px;

            color: var(--muted);
        }


        .top-user {

            display: flex;

            align-items: center;

            gap: 12px;
        }


        .top-user-icon {

            width: 42px;
            height: 42px;

            border-radius: 50%;

            background: #dbeafe;

            color: var(--primary);

            display: flex;

            align-items: center;

            justify-content: center;
        }


        .top-user-text strong {

            display: block;

            font-size: 13px;

            color: var(--dark);
        }


        .top-user-text span {

            font-size: 11px;

            color: var(--muted);
        }


        /* =====================================================
           CONTENT
           ====================================================== */

        .content {

            padding: 30px;
        }


        /* =====================================================
           WELCOME
           ====================================================== */

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

            padding: 28px 30px;

            margin-bottom: 25px;

            position: relative;

            overflow: hidden;

            box-shadow:
                0 10px 25px
                rgba(37,99,235,.18);
        }


        .welcome::after {

            content: "";

            position: absolute;

            width: 220px;
            height: 220px;

            border-radius: 50%;

            background:
                rgba(255,255,255,.08);

            right: -70px;

            top: -90px;
        }


        .welcome h2 {

            font-size: 24px;

            margin-bottom: 7px;
        }


        .welcome p {

            color: #dbeafe;

            font-size: 14px;
        }


        /* =====================================================
           KPI CARDS
           ====================================================== */

        .cards {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 18px;

            margin-bottom: 25px;
        }


        .card {

            background: white;

            border:
                1px solid var(--border);

            border-radius: var(--radius);

            padding: 20px;

            box-shadow: var(--shadow);

            transition: .2s;
        }


        .card:hover {

            transform: translateY(-3px);

            box-shadow:
                0 10px 25px
                rgba(15,23,42,.10);
        }


        .card-top {

            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 18px;
        }


        .card-icon {

            width: 45px;
            height: 45px;

            border-radius: 12px;

            display: flex;

            align-items: center;

            justify-content: center;
        }


        .icon-blue {

            background: #dbeafe;
            color: #2563eb;
        }


        .icon-green {

            background: #dcfce7;
            color: #16a34a;
        }


        .icon-orange {

            background: #ffedd5;
            color: #ea580c;
        }


        .icon-purple {

            background: #f3e8ff;
            color: #9333ea;
        }


        .card-label {

            color: var(--muted);

            font-size: 13px;
        }


        .card-value {

            color: var(--dark);

            font-size: 28px;

            font-weight: 700;

            margin-top: 5px;
        }


        .card-footer {

            margin-top: 8px;

            color: var(--muted);

            font-size: 11px;
        }


        /* =====================================================
           SECONDARY KPI
           ====================================================== */

        .secondary-cards {

            display: grid;

            grid-template-columns:
                repeat(2, 1fr);

            gap: 18px;

            margin-bottom: 25px;
        }


        .secondary-card {

            background: white;

            border:
                1px solid var(--border);

            border-radius: var(--radius);

            padding: 22px;

            box-shadow: var(--shadow);

            display: flex;

            align-items: center;

            justify-content: space-between;
        }


        .secondary-left {

            display: flex;

            align-items: center;

            gap: 15px;
        }


        .secondary-icon {

            width: 52px;
            height: 52px;

            border-radius: 14px;

            display: flex;

            align-items: center;

            justify-content: center;
        }


        .secondary-card h3 {

            color: var(--muted);

            font-size: 13px;

            font-weight: 500;
        }


        .secondary-card strong {

            display: block;

            color: var(--dark);

            font-size: 25px;

            margin-top: 3px;
        }


        .stock-danger {

            color: var(--danger) !important;
        }


        /* =====================================================
           GRID PRINCIPAL
           ====================================================== */

        .dashboard-grid {

            display: grid;

            grid-template-columns:
                2fr 1fr;

            gap: 20px;

            margin-bottom: 25px;
        }


        .panel {

            background: white;

            border:
                1px solid var(--border);

            border-radius: var(--radius);

            box-shadow: var(--shadow);

            overflow: hidden;
        }


        .panel-header {

            padding: 20px;

            border-bottom:
                1px solid var(--border);

            display: flex;

            align-items: center;

            justify-content: space-between;
        }


        .panel-header h3 {

            color: var(--dark);

            font-size: 16px;

            display: flex;

            align-items: center;

            gap: 9px;
        }


        .panel-header h3 svg {

            width: 18px;

            color: var(--primary);
        }


        .panel-header span {

            font-size: 11px;

            color: var(--muted);
        }


        .chart-container {

            padding: 20px;

            height: 330px;
        }


        /* =====================================================
           TABLA
           ====================================================== */

        .table-wrapper {

            overflow-x: auto;
        }


        table {

            width: 100%;

            border-collapse: collapse;
        }


        th {

            background: #f8fafc;

            color: #64748b;

            font-size: 11px;

            text-transform: uppercase;

            letter-spacing: .4px;

            text-align: left;

            padding: 12px 16px;

            white-space: nowrap;
        }


        td {

            padding: 14px 16px;

            border-top:
                1px solid var(--border);

            font-size: 13px;

            color: #475569;

            white-space: nowrap;
        }


        tbody tr:hover {

            background: #f8fafc;
        }


        .invoice-number {

            color: var(--primary);

            font-weight: 600;
        }


        .amount {

            font-weight: 700;

            color: var(--dark);
        }


        /* =====================================================
           ESTADOS
           ====================================================== */

        .badge {

            display: inline-flex;

            align-items: center;

            padding: 5px 9px;

            border-radius: 20px;

            font-size: 10px;

            font-weight: 600;

            text-transform: uppercase;
        }


        .badge-success {

            background: #dcfce7;

            color: #15803d;
        }


        .badge-warning {

            background: #fef3c7;

            color: #b45309;
        }


        .badge-danger {

            background: #fee2e2;

            color: #b91c1c;
        }


        .stock-number {

            font-weight: 700;

            color: var(--danger);
        }


        /* =====================================================
           MENSAJES VACÍOS
           ====================================================== */

        .empty {

            padding: 40px 20px;

            text-align: center;

            color: var(--muted);
        }


        .empty svg {

            width: 38px;
            height: 38px;

            margin-bottom: 10px;

            opacity: .5;
        }


        .empty p {

            font-size: 13px;
        }


        /* =====================================================
           ACCESOS RÁPIDOS
           ====================================================== */

        .quick-grid {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 15px;

            margin-bottom: 25px;
        }


        .quick {

            background: white;

            border:
                1px solid var(--border);

            border-radius: 14px;

            padding: 18px;

            display: flex;

            align-items: center;

            gap: 12px;

            box-shadow: var(--shadow);

            transition: .2s;
        }


        .quick:hover {

            transform: translateY(-2px);

            border-color: #bfdbfe;

            box-shadow:
                0 8px 20px
                rgba(15,23,42,.08);
        }


        .quick-icon {

            width: 42px;
            height: 42px;

            border-radius: 11px;

            background: #eff6ff;

            color: var(--primary);

            display: flex;

            align-items: center;

            justify-content: center;

            flex-shrink: 0;
        }


        .quick strong {

            display: block;

            color: var(--dark);

            font-size: 13px;
        }


        .quick span {

            display: block;

            color: var(--muted);

            font-size: 10px;

            margin-top: 3px;
        }


        /* =====================================================
           FOOTER
           ====================================================== */

        .footer {

            text-align: center;

            color: var(--muted);

            font-size: 11px;

            padding: 5px 0 20px;
        }


        /* =====================================================
           RESPONSIVE
           ====================================================== */

        @media (max-width: 1200px) {

            .cards {

                grid-template-columns:
                    repeat(2, 1fr);
            }

            .quick-grid {

                grid-template-columns:
                    repeat(2, 1fr);
            }

            .dashboard-grid {

                grid-template-columns: 1fr;
            }
        }


        @media (max-width: 800px) {

            .sidebar {

                width: 220px;
            }

            .main {

                margin-left: 220px;

                width:
                    calc(100% - 220px);
            }

            .content {

                padding: 20px;
            }

            .topbar {

                padding: 0 20px;
            }
        }


        @media (max-width: 650px) {

            .sidebar {

                position: static;

                width: 100%;

                min-height: auto;
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

            .logo {

                height: 65px;
            }

            .topbar {

                height: auto;

                padding: 15px 20px;
            }

            .top-user-text {

                display: none;
            }

            .cards {

                grid-template-columns: 1fr;
            }

            .secondary-cards {

                grid-template-columns: 1fr;
            }

            .quick-grid {

                grid-template-columns: 1fr;
            }

            .content {

                padding: 15px;
            }
        }


        /* =====================================================
           MÓDULOS INTEGRADOS EN EL DASHBOARD
           ====================================================== */

        .content.module-active > *:not(#moduleWorkspace) {
            display: none !important;
        }

        #moduleWorkspace {
            display: none;
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 18px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        #moduleWorkspace.visible {
            display: block;
        }

        .module-toolbar {
            min-height: 70px;
            padding: 16px 20px;
            background: linear-gradient(135deg, #0f172a, #1e3a8a);
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            flex-wrap: wrap;
        }

        .module-toolbar-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .module-toolbar-icon {
            width: 42px;
            height: 42px;
            border-radius: 11px;
            background: rgba(255,255,255,.12);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .module-toolbar-icon svg {
            width: 21px;
            height: 21px;
        }

        .module-toolbar h2 {
            margin: 0;
            font-size: 19px;
        }

        .module-toolbar p {
            margin: 3px 0 0;
            color: #dbeafe;
            font-size: 12px;
        }

        .module-close {
            border: 1px solid rgba(255,255,255,.22);
            background: rgba(255,255,255,.10);
            color: white;
            border-radius: 9px;
            padding: 10px 14px;
            cursor: pointer;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            transition: .2s;
        }

        .module-close:hover {
            background: rgba(255,255,255,.18);
            transform: translateY(-1px);
        }

        #moduleFrame {
            display: block;
            width: 100%;
            height: 850px;
            min-height: 700px;
            border: 0;
            background: #f1f5f9;
        }

        .module-loading {
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            padding: 14px 20px;
            background: white;
            border: 1px solid var(--border);
            border-radius: 12px;
            box-shadow: var(--shadow);
            color: var(--dark);
            font-weight: 700;
            z-index: 2;
        }

        .module-frame-wrap {
            position: relative;
        }

        @media (max-width: 700px) {
            #moduleFrame {
                height: 900px;
                min-height: 700px;
            }

            .module-toolbar {
                align-items: flex-start;
            }
        }

    </style>

</head>


<body>


<div class="layout">


    <!-- =====================================================
         SIDEBAR
         ====================================================== -->

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


            <a href="<%= request.getContextPath() %>/dashboard"
               class="active">

                <i data-lucide="layout-dashboard"></i>

                <span>Inicio</span>

            </a>


            <a href="#" onclick="cargarModulo('<%= request.getContextPath() %>/clientes', 'Clientes y Vehículos', 'users', this); return false;">

                <i data-lucide="users"></i>

                <span>Clientes y Vehículos</span>

            </a>


            <a href="#" onclick="cargarModulo('<%= request.getContextPath() %>/inventario', 'Inventario', 'package', this); return false;">

                <i data-lucide="package"></i>

                <span>Inventario</span>

            </a>


            <a href="#" onclick="cargarModulo('<%= request.getContextPath() %>/facturacion', 'Facturación', 'file-text', this); return false;">

                <i data-lucide="file-text"></i>

                <span>Facturación</span>

            </a>


            <div class="menu-title" style="margin-top:15px;">
                Gestión
            </div>


            <a href="#" onclick="cargarModulo('<%= request.getContextPath() %>/reportes', 'Reportes', 'bar-chart-3', this); return false;">

                <i data-lucide="bar-chart-3"></i>

                <span>Reportes</span>

            </a>


            <%
    String rolMenu = String.valueOf(session.getAttribute("rol"));
%>

<% if ("ADMIN".equalsIgnoreCase(rolMenu)) { %>
    <a href="#" onclick="cargarModulo('<%=request.getContextPath()%>/configuracion', 'Configuración', 'settings', this); return false;">
        <i data-lucide="settings"></i>
        Configuración
    </a>
<% } %>

            </a>

        </nav>


        <div class="sidebar-footer">


            <div class="user-mini">

                <div class="avatar">

                    <%= nombreUsuario.substring(0,1).toUpperCase() %>

                </div>

                <div class="user-info">

                    <strong>
                        <%= nombreUsuario %>
                    </strong>

                    <span>
                        <%= rol %>
                    </span>

                </div>

            </div>


            <form method="post"
                  action="<%= request.getContextPath() %>/logout">

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
         ====================================================== -->

    <main class="main">


        <!-- =================================================
             TOPBAR
             ================================================== -->

        <header class="topbar">


            <div class="page-title">

                <h1>Inicio</h1>

                <p>
                    Panel general de TALLER LONDOÑO
                </p>

            </div>


            <div class="top-user">

                <div class="top-user-icon">

                    <i data-lucide="user"></i>

                </div>

                <div class="top-user-text">

                    <strong>
                        <%= nombreUsuario %>
                    </strong>

                    <span>
                        Usuario <%= rol %>
                    </span>

                </div>

            </div>

        </header>



        <!-- =================================================
             CONTENIDO
             ================================================== -->

        <section class="content">

            <!-- =================================================
                 ÁREA DE MÓDULOS INTEGRADOS
                 ================================================== -->
            <div id="moduleWorkspace">

                <div class="module-toolbar">

                    <div class="module-toolbar-info">

                        <div class="module-toolbar-icon">
                            <i id="moduleToolbarIcon" data-lucide="layout-dashboard"></i>
                        </div>

                        <div>
                            <h2 id="moduleToolbarTitle">
                                Módulo
                            </h2>

                            <p id="moduleToolbarDescription">
                                Gestión integrada dentro de SIGTAL
                            </p>
                        </div>

                    </div>

                    <button
                        type="button"
                        class="module-close"
                        onclick="cerrarModulo()">

                        <i data-lucide="arrow-left"></i>
                        Volver al Dashboard

                    </button>

                </div>

                <div class="module-frame-wrap">

                    <div
                        id="moduleLoading"
                        class="module-loading"
                        style="display:none;">

                        Cargando módulo...

                    </div>

                    <iframe
                        id="moduleFrame"
                        title="Módulo SIGTAL"
                        loading="eager">
                    </iframe>

                </div>

            </div>


            <!-- =================================================
                 BIENVENIDA
                 ================================================== -->

            <div class="welcome">

                <h2>
                    ¡Bienvenido, <%= nombreUsuario %>! 👋
                </h2>

                <p>
                    Consulta el estado general del taller,
                    las ventas, facturación e inventario.
                </p>

            </div>



            <!-- =================================================
                 KPI PRINCIPALES
                 ================================================== -->

            <div class="cards">


                <!-- CLIENTES -->

                <div class="card">

                    <div class="card-top">

                        <div>

                            <div class="card-label">
                                Clientes registrados
                            </div>

                            <div class="card-value">
                                <%= totalClientes %>
                            </div>

                        </div>

                        <div class="card-icon icon-blue">

                            <i data-lucide="users"></i>

                        </div>

                    </div>

                    <div class="card-footer">
                        Clientes activos en SIGTAL
                    </div>

                </div>


                <!-- VEHÍCULOS -->

                <div class="card">

                    <div class="card-top">

                        <div>

                            <div class="card-label">
                                Vehículos
                            </div>

                            <div class="card-value">
                                <%= totalVehiculos %>
                            </div>

                        </div>

                        <div class="card-icon icon-green">

                            <i data-lucide="car-front"></i>

                        </div>

                    </div>

                    <div class="card-footer">
                        Vehículos registrados
                    </div>

                </div>


                <!-- PRODUCTOS -->

                <div class="card">

                    <div class="card-top">

                        <div>

                            <div class="card-label">
                                Productos
                            </div>

                            <div class="card-value">
                                <%= totalProductos %>
                            </div>

                        </div>

                        <div class="card-icon icon-orange">

                            <i data-lucide="package"></i>

                        </div>

                    </div>

                    <div class="card-footer">
                        Productos del inventario
                    </div>

                </div>


                <!-- FACTURAS -->

                <div class="card">

                    <div class="card-top">

                        <div>

                            <div class="card-label">
                                Facturas
                            </div>

                            <div class="card-value">
                                <%= totalFacturas %>
                            </div>

                        </div>

                        <div class="card-icon icon-purple">

                            <i data-lucide="receipt"></i>

                        </div>

                    </div>

                    <div class="card-footer">
                        Facturas registradas
                    </div>

                </div>

            </div>



            <!-- =================================================
                 VENTAS / STOCK
                 ================================================== -->

            <div class="secondary-cards">


                <div class="secondary-card">

                    <div class="secondary-left">

                        <div class="secondary-icon icon-green">

                            <i data-lucide="circle-dollar-sign"></i>

                        </div>

                        <div>

                            <h3>
                                Ventas acumuladas
                            </h3>

                            <strong>
                                <%= formatoMoneda.format(totalVentas) %>
                            </strong>

                        </div>

                    </div>

                    <i data-lucide="trending-up"
                       style="color:#16a34a;">
                    </i>

                </div>



                <div class="secondary-card">

                    <div class="secondary-left">

                        <div class="secondary-icon icon-orange">

                            <i data-lucide="triangle-alert"></i>

                        </div>

                        <div>

                            <h3>
                                Productos con stock bajo
                            </h3>

                            <strong class="<%= productosStockBajo > 0 ? "stock-danger" : "" %>">

                                <%= productosStockBajo %>

                            </strong>

                        </div>

                    </div>

                    <i data-lucide="package-alert"
                       style="color:#d97706;">
                    </i>

                </div>

            </div>



            <!-- =================================================
                 GRÁFICO + STOCK
                 ================================================== -->

            <div class="dashboard-grid">


                <!-- GRÁFICO -->

                <div class="panel">

                    <div class="panel-header">

                        <h3>

                            <i data-lucide="chart-column"></i>

                            Ventas por mes

                        </h3>

                        <span>
                            Últimos meses registrados
                        </span>

                    </div>


                    <div class="chart-container">

                        <canvas id="ventasChart"></canvas>

                    </div>

                </div>



                <!-- STOCK BAJO -->

                <div class="panel">

                    <div class="panel-header">

                        <h3>

                            <i data-lucide="package-alert"></i>

                            Stock bajo

                        </h3>

                        <span>
                            Inventario
                        </span>

                    </div>


                    <% if (detalleStockBajo.isEmpty()) { %>

                        <div class="empty">

                            <i data-lucide="circle-check"></i>

                            <p>
                                No hay productos con stock bajo.
                            </p>

                        </div>

                    <% } else { %>


                        <div class="table-wrapper">

                            <table>

                                <thead>

                                    <tr>

                                        <th>
                                            Producto
                                        </th>

                                        <th>
                                            Cantidad
                                        </th>

                                        <th>
                                            Mínimo
                                        </th>

                                    </tr>

                                </thead>


                                <tbody>

                                <% for (Map<String,Object> producto : detalleStockBajo) { %>

                                    <tr>

                                        <td>

                                            <strong>
                                                <%= producto.get("nombre") %>
                                            </strong>

                                            <br>

                                            <small style="color:#94a3b8;">
                                                <%= producto.get("codigo") %>
                                            </small>

                                        </td>

                                        <td class="stock-number">
                                            <%= producto.get("cantidad") %>
                                        </td>

                                        <td>
                                            <%= producto.get("stock_minimo") %>
                                        </td>

                                    </tr>

                                <% } %>

                                </tbody>

                            </table>

                        </div>

                    <% } %>

                </div>

            </div>



            <!-- =================================================
                 ÚLTIMAS FACTURAS
                 ================================================== -->

            <div class="panel"
                 style="margin-bottom:25px;">


                <div class="panel-header">

                    <h3>

                        <i data-lucide="receipt-text"></i>

                        Últimas facturas

                    </h3>

                    <span>
                        Últimos movimientos
                    </span>

                </div>


                <% if (ultimasFacturas.isEmpty()) { %>

                    <div class="empty">

                        <i data-lucide="file-x"></i>

                        <p>
                            No existen facturas registradas.
                        </p>

                    </div>

                <% } else { %>


                    <div class="table-wrapper">

                        <table>

                            <thead>

                                <tr>

                                    <th>
                                        Factura
                                    </th>

                                    <th>
                                        Fecha
                                    </th>

                                    <th>
                                        Cliente
                                    </th>

                                    <th>
                                        Total
                                    </th>

                                    <th>
                                        Estado
                                    </th>

                                </tr>

                            </thead>


                            <tbody>

                            <% for (Map<String,Object> factura : ultimasFacturas) { %>

                                <tr>

                                    <td class="invoice-number">

                                        #<%= factura.get("numero_factura") %>

                                    </td>


                                    <td>

                                        <%
                                            Object fechaObj =
                                                    factura.get("fecha_factura");

                                            String fechaTexto = "";

                                            if (fechaObj instanceof Date) {

                                                fechaTexto =
                                                        formatoFecha.format(
                                                                (Date) fechaObj
                                                        );

                                            } else if (fechaObj != null) {

                                                fechaTexto =
                                                        fechaObj.toString();
                                            }
                                        %>

                                        <%= fechaTexto %>

                                    </td>


                                    <td>

                                        <%= factura.get("cliente") %>

                                    </td>


                                    <td class="amount">

                                        <%
                                            Object totalFactura =
                                                    factura.get("total");

                                            double totalNumerico = 0;

                                            if (totalFactura instanceof Number) {

                                                totalNumerico =
                                                        ((Number) totalFactura)
                                                                .doubleValue();

                                            } else if (totalFactura != null) {

                                                try {

                                                    totalNumerico =
                                                            Double.parseDouble(
                                                                    totalFactura.toString()
                                                            );

                                                } catch (Exception e) {

                                                    totalNumerico = 0;
                                                }
                                            }
                                        %>

                                        <%= formatoMoneda.format(totalNumerico) %>

                                    </td>


                                    <td>

                                        <%
                                            String estadoFactura =
                                                    factura.get("estado") == null
                                                    ? ""
                                                    : factura.get("estado")
                                                            .toString()
                                                            .toUpperCase();

                                            String claseEstado =
                                                    "badge-success";

                                            if (estadoFactura.contains("ANUL")
                                                    || estadoFactura.contains("CANCEL")) {

                                                claseEstado =
                                                        "badge-danger";

                                            } else if (estadoFactura.contains("PEND")) {

                                                claseEstado =
                                                        "badge-warning";
                                            }
                                        %>


                                        <span class="badge <%= claseEstado %>">

                                            <%= estadoFactura %>

                                        </span>

                                    </td>

                                </tr>

                            <% } %>

                            </tbody>

                        </table>

                    </div>

                <% } %>

            </div>



            <!-- =================================================
                 ACCESOS RÁPIDOS
                 ================================================== -->

            <div class="panel"
                 style="margin-bottom:25px;">


                <div class="panel-header">

                    <h3>

                        <i data-lucide="zap"></i>

                        Accesos rápidos

                    </h3>

                    <span>
                        Gestión del taller
                    </span>

                </div>


                <div style="padding:20px;">


                    <div class="quick-grid">


                        <a class="quick"
                         href="<%= request.getContextPath() %>/clientes">

                            <div class="quick-icon">

                                <i data-lucide="user-plus"></i>

                            </div>

                            <div>

                                <strong>
                                    Clientes
                                </strong>

                                <span>
                                    Gestionar clientes y vehículos
                                </span>

                            </div>

                        </a>



                        <a class="quick"
                           href="<%= request.getContextPath() %>/inventario">

                            <div class="quick-icon">

                                <i data-lucide="package-plus"></i>

                            </div>

                            <div>

                                <strong>
                                    Inventario
                                </strong>

                                <span>
                                    Administrar productos
                                </span>

                            </div>

                        </a>



                        <a class="quick"
                           href="<%= request.getContextPath() %>/facturacion">

                            <div class="quick-icon">

                                <i data-lucide="file-plus-2"></i>

                            </div>

                            <div>

                                <strong>
                                    Nueva factura
                                </strong>

                                <span>
                                    Registrar una venta
                                </span>

                            </div>

                        </a>



                        <a class="quick" href="#"
                           onclick="cargarModulo('<%= request.getContextPath() %>/reportes', 'Reportes', 'bar-chart-3', null); return false;">

                            <div class="quick-icon">

                                <i data-lucide="bar-chart-3"></i>

                            </div>

                            <div>

                                <strong>
                                    Reportes
                                </strong>

                                <span>
                                    Consultar información
                                </span>

                            </div>

                        </a>


                    </div>

                </div>

            </div>



            <!-- =================================================
                 PIE
                 ================================================== -->

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
     JAVASCRIPT
     ========================================================== -->

<script>

    /* =========================================================
       MÓDULOS INTEGRADOS EN EL DASHBOARD
       ========================================================== */

    const moduleWorkspace =
        document.getElementById("moduleWorkspace");

    const moduleFrame =
        document.getElementById("moduleFrame");

    const moduleLoading =
        document.getElementById("moduleLoading");

    const moduleTitle =
        document.getElementById("moduleToolbarTitle");

    const moduleDescription =
        document.getElementById("moduleToolbarDescription");

    const moduleIcon =
        document.getElementById("moduleToolbarIcon");

    const dashboardContent =
        document.querySelector(".content");

    function cargarModulo(url, titulo, icono, elementoMenu) {

        if (!moduleWorkspace || !moduleFrame) {
            return;
        }

        moduleTitle.textContent = titulo;
        moduleDescription.textContent =
            "Gestión de " + titulo.toLowerCase() + " dentro de SIGTAL";

        const iconContainer =
            document.querySelector(".module-toolbar-icon");

        if (iconContainer) {
            iconContainer.innerHTML =
                '<i data-lucide="' + icono + '"></i>';
        }

        moduleWorkspace.classList.add("visible");
        dashboardContent.classList.add("module-active");

        moduleLoading.style.display = "block";
        moduleFrame.style.visibility = "hidden";

        /*
         * El iframe mantiene intacta la funcionalidad de cada módulo:
         * formularios, búsquedas, botones, mensajes, impresión y WhatsApp.
         */
        moduleFrame.src = url;

        document.querySelectorAll(".menu a").forEach(function(a) {
            a.classList.remove("active");
        });

        if (elementoMenu) {
            elementoMenu.classList.add("active");
        }

        lucide.createIcons();

        /*
         * Llevar al usuario al inicio del área de trabajo.
         */
        window.scrollTo({
            top: 0,
            behavior: "smooth"
        });
    }

    function cerrarModulo() {

        if (!moduleWorkspace || !moduleFrame) {
            return;
        }

        moduleWorkspace.classList.remove("visible");
        dashboardContent.classList.remove("module-active");

        moduleFrame.src = "about:blank";

        document.querySelectorAll(".menu a").forEach(function(a) {
            a.classList.remove("active");
        });

        const inicio =
            document.querySelector(
                '.menu a[href*="/dashboard"]'
            );

        if (inicio) {
            inicio.classList.add("active");
        }

        lucide.createIcons();

        window.scrollTo({
            top: 0,
            behavior: "smooth"
        });
    }

    /*
     * Oculta los encabezados propios de los módulos para que
     * visualmente parezcan parte del Dashboard y no otra página.
     */
    moduleFrame.addEventListener("load", function() {

        moduleLoading.style.display = "none";
        moduleFrame.style.visibility = "visible";

        try {

            const doc = moduleFrame.contentDocument;

            if (!doc || !doc.head) {
                return;
            }

            const estilosIntegracion =
                doc.createElement("style");

            estilosIntegracion.textContent = `
                html, body {
                    margin: 0 !important;
                    padding: 0 !important;
                    background: #f1f5f9 !important;
                }

                body {
                    min-height: auto !important;
                }

                .header {
                    display: none !important;
                }

                .encabezado {
                    display: none !important;
                }

                /* Ocultar la navegación interna del módulo.
                   El Dashboard conserva la navegación principal. */
                .layout > .sidebar {
                    display: none !important;
                }

                .layout > .main {
                    margin-left: 0 !important;
                    width: 100% !important;
                    min-height: auto !important;
                }

                .topbar {
                    display: none !important;
                }

                .container {
                    width: 100% !important;
                    max-width: none !important;
                    margin: 0 !important;
                    padding: 22px !important;
                }

                .contenedor {
                    max-width: none !important;
                    margin: 0 !important;
                    padding: 22px !important;
                }

                .titulo {
                    margin-top: 0 !important;
                }

                @media (max-width: 700px) {
                    .container,
                    .contenedor {
                        padding: 14px !important;
                    }
                }
            `;

            doc.head.appendChild(estilosIntegracion);

            /*
             * Volver a crear iconos si el módulo usa Lucide.
             */
            if (moduleFrame.contentWindow.lucide) {
                moduleFrame.contentWindow.lucide.createIcons();
            }

        } catch (error) {

            console.warn(
                "No se pudo aplicar el estilo integrado:",
                error
            );

        }
    });


    /* =========================================================
       ICONOS
       ========================================================== */

    lucide.createIcons();



    /* =========================================================
       GRÁFICO DE VENTAS
       ========================================================== */

    const etiquetasVentas = [
        <%= etiquetasGrafico.toString() %>
    ];


    const valoresVentas = [
        <%= valoresGrafico.toString() %>
    ];


    const canvas =
        document.getElementById("ventasChart");


    if (canvas) {

        new Chart(canvas, {

            type: "line",

            data: {

                labels: etiquetasVentas,

                datasets: [

                    {

                        label: "Ventas",

                        data: valoresVentas,

                        borderWidth: 3,

                        tension: 0.35,

                        fill: true,

                        pointRadius: 4,

                        pointHoverRadius: 6

                    }

                ]

            },


            options: {

                responsive: true,

                maintainAspectRatio: false,


                interaction: {

                    intersect: false,

                    mode: "index"

                },


                plugins: {

                    legend: {

                        display: false

                    },


                    tooltip: {

                        callbacks: {

                            label: function(context) {

                                const valor =
                                    Number(context.raw || 0);

                                return "Ventas: $" +
                                    valor.toLocaleString(
                                        "es-CO"
                                    );

                            }

                        }

                    }

                },


                scales: {

                    y: {

                        beginAtZero: true,

                        ticks: {

                            callback: function(value) {

                                return "$" +
                                    Number(value)
                                        .toLocaleString(
                                            "es-CO"
                                        );
                            }

                        },

                        grid: {

                            color:
                                "rgba(148,163,184,.15)"
                        }

                    },


                    x: {

                        grid: {

                            display: false

                        }

                    }

                }

            }

        });

    }

</script>


</body>

</html
