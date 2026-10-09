<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Date" %>

<%

    Map<String,Object> resumen =
            (Map<String,Object>) request.getAttribute("resumen");

    List<Map<String,Object>> ventas =
            (List<Map<String,Object>>) request.getAttribute("ventas");

    List<Map<String,Object>> clientes =
            (List<Map<String,Object>>) request.getAttribute("clientesReporte");

    List<Map<String,Object>> facturas =
            (List<Map<String,Object>>) request.getAttribute("facturasReporte");

    List<Map<String,Object>> inventario =
            (List<Map<String,Object>>) request.getAttribute("inventarioReporte");

    List<Map<String,Object>> stockBajo =
            (List<Map<String,Object>>) request.getAttribute("stockBajoReporte");


    if (ventas == null)
        ventas = new java.util.ArrayList<>();

    if (clientes == null)
        clientes = new java.util.ArrayList<>();

    if (facturas == null)
        facturas = new java.util.ArrayList<>();

    if (inventario == null)
        inventario = new java.util.ArrayList<>();

    if (stockBajo == null)
        stockBajo = new java.util.ArrayList<>();


    double totalVentas = 0;

    int totalFacturas = 0;

    double promedioFactura = 0;


    if (resumen != null) {

        if (resumen.get("totalVentas") != null)
            totalVentas =
                    ((Number) resumen.get("totalVentas"))
                            .doubleValue();

        if (resumen.get("totalFacturas") != null)
            totalFacturas =
                    ((Number) resumen.get("totalFacturas"))
                            .intValue();

        if (resumen.get("promedioFactura") != null)
            promedioFactura =
                    ((Number) resumen.get("promedioFactura"))
                            .doubleValue();
    }


    Double valorInventarioObj =
            (Double) request.getAttribute("valorInventario");

    double valorInventario =
            valorInventarioObj == null
            ? 0
            : valorInventarioObj;


    String fechaInicio =
            (String) request.getAttribute("fechaInicio");

    String fechaFin =
            (String) request.getAttribute("fechaFin");


    String nombreUsuario =
            (String) session.getAttribute("nombreUsuario");

    String rol =
            (String) session.getAttribute("rol");


    if (nombreUsuario == null)
        nombreUsuario = "Administrador";

    if (rol == null)
        rol = "ADMIN";


    NumberFormat moneda =
            NumberFormat.getCurrencyInstance(
                    new Locale("es","CO")
            );

    moneda.setMaximumFractionDigits(0);


    SimpleDateFormat fechaFormato =
            new SimpleDateFormat("dd/MM/yyyy");

%>


<!DOCTYPE html>

<html lang="es">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Reportes | SIGTAL</title>


<script src="https://unpkg.com/lucide@latest"></script>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


<style>

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

    background: #f1f5f9;

    color: #334155;
}


.layout {

    display: flex;

    min-height: 100vh;
}


/* =========================================================
   SIDEBAR
   ========================================================= */

.sidebar {

    width: 250px;

    position: fixed;

    top: 0;
    bottom: 0;
    left: 0;

    background:
        linear-gradient(
            180deg,
            #0f172a,
            #172554
        );

    color: white;

    display: flex;

    flex-direction: column;
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

    background: #2563eb;

    display: flex;

    align-items: center;

    justify-content: center;
}


.logo-text strong {

    display: block;

    font-size: 20px;
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

    font-size: 10px;

    text-transform: uppercase;

    letter-spacing: 1px;

    color: #64748b;

    padding: 10px 14px;
}


.menu a {

    display: flex;

    align-items: center;

    gap: 12px;

    color: #cbd5e1;

    padding: 12px 14px;

    margin-bottom: 4px;

    border-radius: 10px;

    font-size: 14px;

    text-decoration: none;

    transition: .2s;
}


.menu a:hover {

    background:
        rgba(255,255,255,.08);

    color: white;
}


.menu a.active {

    background: #2563eb;

    color: white;
}


.menu svg {

    width: 18px;
}


.sidebar-footer {

    padding: 16px;

    border-top:
        1px solid rgba(255,255,255,.08);
}


.user {

    display: flex;

    align-items: center;

    gap: 10px;

    margin-bottom: 12px;
}


.avatar {

    width: 38px;
    height: 38px;

    border-radius: 50%;

    background: #2563eb;

    display: flex;

    align-items: center;

    justify-content: center;

    font-weight: bold;
}


.user strong {

    display: block;

    font-size: 13px;
}


.user span {

    font-size: 11px;

    color: #94a3b8;
}


.logout {

    width: 100%;

    border: 0;

    padding: 10px;

    border-radius: 8px;

    background:
        rgba(220,38,38,.12);

    color: #fca5a5;

    cursor: pointer;

    display: flex;

    align-items: center;

    justify-content: center;

    gap: 8px;
}


/* =========================================================
   MAIN
   ========================================================= */

.main {

    margin-left: 250px;

    width:
        calc(100% - 250px);
}


.topbar {

    height: 80px;

    background: white;

    border-bottom:
        1px solid #e2e8f0;

    padding: 0 30px;

    display: flex;

    align-items: center;

    justify-content: space-between;
}


.topbar h1 {

    color: #0f172a;

    font-size: 24px;
}


.topbar p {

    color: #64748b;

    font-size: 13px;

    margin-top: 3px;
}


.top-user {

    display: flex;

    align-items: center;

    gap: 10px;
}


.top-user-icon {

    width: 40px;
    height: 40px;

    border-radius: 50%;

    background: #dbeafe;

    color: #2563eb;

    display: flex;

    align-items: center;

    justify-content: center;
}


.content {

    padding: 30px;
}


/* =========================================================
   FILTER
   ========================================================= */

.filter {

    background: white;

    padding: 20px;

    border-radius: 16px;

    border:
        1px solid #e2e8f0;

    box-shadow:
        0 4px 15px rgba(15,23,42,.06);

    margin-bottom: 20px;
}


.filter-title {

    display: flex;

    align-items: center;

    gap: 8px;

    font-weight: 700;

    color: #0f172a;

    margin-bottom: 15px;
}


.filter-form {

    display: grid;

    grid-template-columns:
        1fr 1fr auto;

    gap: 12px;

    align-items: end;
}


.form-group label {

    display: block;

    font-size: 12px;

    font-weight: 600;

    color: #475569;

    margin-bottom: 6px;
}


.form-group input {

    width: 100%;

    padding: 10px 12px;

    border:
        1px solid #cbd5e1;

    border-radius: 9px;

    outline: none;
}


.form-group input:focus {

    border-color: #2563eb;

    box-shadow:
        0 0 0 3px #dbeafe;
}


.btn {

    border: none;

    padding: 11px 18px;

    border-radius: 9px;

    background: #2563eb;

    color: white;

    cursor: pointer;

    display: flex;

    align-items: center;

    gap: 7px;

    font-weight: 600;
}


.btn:hover {

    background: #1d4ed8;
}


/* =========================================================
   CARDS
   ========================================================= */

.cards {

    display: grid;

    grid-template-columns:
        repeat(4,1fr);

    gap: 18px;

    margin-bottom: 20px;
}


.card {

    background: white;

    border:
        1px solid #e2e8f0;

    border-radius: 16px;

    padding: 20px;

    box-shadow:
        0 4px 15px rgba(15,23,42,.06);
}


.card-icon {

    width: 44px;
    height: 44px;

    border-radius: 12px;

    display: flex;

    align-items: center;

    justify-content: center;

    margin-bottom: 14px;
}


.blue {

    background: #dbeafe;

    color: #2563eb;
}


.green {

    background: #dcfce7;

    color: #16a34a;
}


.orange {

    background: #ffedd5;

    color: #ea580c;
}


.purple {

    background: #f3e8ff;

    color: #9333ea;
}


.card label {

    font-size: 12px;

    color: #64748b;
}


.card strong {

    display: block;

    font-size: 25px;

    color: #0f172a;

    margin-top: 5px;
}


/* =========================================================
   PANELS
   ========================================================= */

.panel {

    background: white;

    border:
        1px solid #e2e8f0;

    border-radius: 16px;

    box-shadow:
        0 4px 15px rgba(15,23,42,.06);

    overflow: hidden;

    margin-bottom: 20px;
}


.panel-header {

    padding: 18px 20px;

    border-bottom:
        1px solid #e2e8f0;

    display: flex;

    align-items: center;

    justify-content: space-between;
}


.panel-header h2 {

    font-size: 16px;

    color: #0f172a;

    display: flex;

    align-items: center;

    gap: 8px;
}


.panel-header span {

    font-size: 11px;

    color: #64748b;
}


.chart {

    height: 330px;

    padding: 20px;
}


/* =========================================================
   GRID
   ========================================================= */

.grid {

    display: grid;

    grid-template-columns:
        2fr 1fr;

    gap: 20px;
}


/* =========================================================
   TABLE
   ========================================================= */

.table-wrapper {

    overflow-x: auto;
}


table {

    width: 100%;

    border-collapse: collapse;
}


th {

    padding: 12px 15px;

    text-align: left;

    background: #f8fafc;

    color: #64748b;

    font-size: 10px;

    text-transform: uppercase;

    white-space: nowrap;
}


td {

    padding: 13px 15px;

    border-top:
        1px solid #e2e8f0;

    font-size: 12px;

    white-space: nowrap;
}


td strong {

    color: #0f172a;
}


.badge {

    padding: 5px 9px;

    border-radius: 20px;

    font-size: 10px;

    font-weight: 700;
}


.badge-danger {

    background: #fee2e2;

    color: #b91c1c;
}


.badge-success {

    background: #dcfce7;

    color: #15803d;
}


.badge-warning {

    background: #fef3c7;

    color: #b45309;
}


.empty {

    text-align: center;

    padding: 35px;

    color: #64748b;

    font-size: 13px;
}


/* =========================================================
   RESPONSIVE
   ========================================================= */

@media(max-width:1100px) {

    .cards {

        grid-template-columns:
            repeat(2,1fr);
    }

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

    .cards {

        grid-template-columns: 1fr;
    }

    .filter-form {

        grid-template-columns: 1fr;
    }

    .content {

        padding: 15px;
    }

}

</style>

</head>


<body>


<div class="layout">


<!-- =======================================================
     SIDEBAR
     ======================================================== -->

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


        <a href="<%=request.getContextPath()%>/reportes"
           class="active">

            <i data-lucide="bar-chart-3"></i>

            Reportes

        </a>


        <a href="<%=request.getContextPath()%>/configuracion">

            <i data-lucide="settings"></i>

            Configuración

        </a>

    </nav>


    <div class="sidebar-footer">

        <div class="user">

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



<!-- =======================================================
     MAIN
     ======================================================== -->

<main class="main">


<header class="topbar">

    <div>

        <h1>
            Reportes
        </h1>

        <p>
            Análisis y control de la información de SIGTAL
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



<section class="content">


<!-- =======================================================
     FILTRO
     ======================================================== -->

<div class="filter">


    <div class="filter-title">

        <i data-lucide="calendar-range"></i>

        Filtrar período

    </div>


    <form class="filter-form"
          method="get"
          action="<%=request.getContextPath()%>/reportes">


        <div class="form-group">

            <label>
                Fecha inicial
            </label>

            <input
                type="date"
                name="fechaInicio"
                value="<%=fechaInicio%>"
                required>

        </div>


        <div class="form-group">

            <label>
                Fecha final
            </label>

            <input
                type="date"
                name="fechaFin"
                value="<%=fechaFin%>"
                required>

        </div>


        <button class="btn"
                type="submit">

            <i data-lucide="search"></i>

            Consultar

        </button>

    </form>

</div>



<!-- =======================================================
     CARDS
     ======================================================== -->

<div class="cards">


    <div class="card">

        <div class="card-icon blue">

            <i data-lucide="circle-dollar-sign"></i>

        </div>

        <label>
            Ventas
        </label>

        <strong>
            <%=moneda.format(totalVentas)%>
        </strong>

    </div>


    <div class="card">

        <div class="card-icon purple">

            <i data-lucide="receipt"></i>

        </div>

        <label>
            Facturas
        </label>

        <strong>
            <%=totalFacturas%>
        </strong>

    </div>


    <div class="card">

        <div class="card-icon green">

            <i data-lucide="calculator"></i>

        </div>

        <label>
            Ticket promedio
        </label>

        <strong>
            <%=moneda.format(promedioFactura)%>
        </strong>

    </div>


    <div class="card">

        <div class="card-icon orange">

            <i data-lucide="package"></i>

        </div>

        <label>
            Valor inventario
        </label>

        <strong>
            <%=moneda.format(valorInventario)%>
        </strong>

    </div>

</div>



<!-- =======================================================
     GRÁFICO
     ======================================================== -->

<div class="panel">


    <div class="panel-header">

        <h2>

            <i data-lucide="chart-column"></i>

            Ventas por día

        </h2>

        <span>
            Período seleccionado
        </span>

    </div>


    <div class="chart">

        <canvas id="ventasChart"></canvas>

    </div>

</div>



<!-- =======================================================
     CLIENTES + STOCK
     ======================================================== -->

<div class="grid">


    <!-- CLIENTES -->

    <div class="panel">

        <div class="panel-header">

            <h2>

                <i data-lucide="users"></i>

                Clientes con mayor facturación

            </h2>

            <span>
                Top 10
            </span>

        </div>


        <% if(clientes.isEmpty()) { %>

            <div class="empty">

                No hay información para el período seleccionado.

            </div>

        <% } else { %>


        <div class="table-wrapper">

            <table>

                <thead>

                <tr>

                    <th>
                        Cliente
                    </th>

                    <th>
                        Documento
                    </th>

                    <th>
                        Facturas
                    </th>

                    <th>
                        Total
                    </th>

                </tr>

                </thead>


                <tbody>

                <% for(Map<String,Object> cliente : clientes) { %>

                <tr>

                    <td>
                        <strong>
                            <%=cliente.get("nombre")%>
                        </strong>
                    </td>

                    <td>
                        <%=cliente.get("documento")%>
                    </td>

                    <td>
                        <%=cliente.get("cantidadFacturas")%>
                    </td>

                    <td>
                        <strong>
                            <%=moneda.format(
                                ((Number)cliente.get("totalFacturado"))
                                .doubleValue()
                            )%>
                        </strong>
                    </td>

                </tr>

                <% } %>

                </tbody>

            </table>

        </div>

        <% } %>

    </div>



    <!-- STOCK -->

    <div class="panel">

        <div class="panel-header">

            <h2>

                <i data-lucide="package-alert"></i>

                Stock bajo

            </h2>

            <span>
                Inventario
            </span>

        </div>


        <% if(stockBajo.isEmpty()) { %>

            <div class="empty">

                <i data-lucide="circle-check"></i>

                <br><br>

                No hay productos con stock bajo.

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

                <% for(Map<String,Object> producto : stockBajo) { %>

                <tr>

                    <td>
                        <strong>
                            <%=producto.get("nombre")%>
                        </strong>
                    </td>

                    <td>

                        <span class="badge badge-danger">

                            <%=producto.get("cantidad")%>

                        </span>

                    </td>

                    <td>
                        <%=producto.get("stockMinimo")%>
                    </td>

                </tr>

                <% } %>

                </tbody>

            </table>

        </div>

        <% } %>

    </div>

</div>



<!-- =======================================================
     FACTURAS
     ======================================================== -->

<div class="panel">


    <div class="panel-header">

        <h2>

            <i data-lucide="file-text"></i>

            Facturas del período

        </h2>

        <span>
            Máximo 50 resultados
        </span>

    </div>


    <% if(facturas.isEmpty()) { %>

        <div class="empty">

            No hay facturas para el período seleccionado.

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
                    Subtotal
                </th>

                <th>
                    Descuento
                </th>

                <th>
                    Impuesto
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


            <% for(Map<String,Object> factura : facturas) { %>


            <tr>


                <td>

                    <strong>
                        #<%=factura.get("numeroFactura")%>
                    </strong>

                </td>


                <td>

                    <%
                        Object fechaObj =
                                factura.get("fechaFactura");

                        String fechaTexto = "";

                        if(fechaObj instanceof Date) {

                            fechaTexto =
                                    fechaFormato.format(
                                            (Date)fechaObj
                                    );

                        } else if(fechaObj != null) {

                            fechaTexto =
                                    fechaObj.toString();
                        }
                    %>

                    <%=fechaTexto%>

                </td>


                <td>

                    <%=factura.get("cliente")%>

                </td>


                <td>

                    <%=moneda.format(
                        ((Number)factura.get("subtotal"))
                        .doubleValue()
                    )%>

                </td>


                <td>

                    <%=moneda.format(
                        ((Number)factura.get("descuento"))
                        .doubleValue()
                    )%>

                </td>


                <td>

                    <%=moneda.format(
                        ((Number)factura.get("impuesto"))
                        .doubleValue()
                    )%>

                </td>


                <td>

                    <strong>

                        <%=moneda.format(
                            ((Number)factura.get("total"))
                            .doubleValue()
                        )%>

                    </strong>

                </td>


                <td>

                    <%
                        String estado =
                                String.valueOf(
                                    factura.get("estado")
                                ).toUpperCase();

                        String clase =
                                "badge-success";

                        if(estado.contains("ANUL")
                                || estado.contains("CANCEL")) {

                            clase = "badge-danger";

                        } else if(estado.contains("PEND")) {

                            clase = "badge-warning";
                        }
                    %>


                    <span class="badge <%=clase%>">

                        <%=estado%>

                    </span>

                </td>


            </tr>


            <% } %>


            </tbody>

        </table>

    </div>

    <% } %>

</div>



<!-- =======================================================
     INVENTARIO
     ======================================================== -->

<div class="panel">


    <div class="panel-header">

        <h2>

            <i data-lucide="boxes"></i>

            Inventario

        </h2>

        <span>
            Productos registrados
        </span>

    </div>


    <div class="table-wrapper">

        <table>

            <thead>

            <tr>

                <th>
                    Código
                </th>

                <th>
                    Producto
                </th>

                <th>
                    Categoría
                </th>

                <th>
                    Marca
                </th>

                <th>
                    Cantidad
                </th>

                <th>
                    Mínimo
                </th>

                <th>
                    Precio venta
                </th>

                <th>
                    Estado
                </th>

            </tr>

            </thead>


            <tbody>


            <% for(Map<String,Object> producto : inventario) { %>


            <tr>

                <td>
                    <%=producto.get("codigo")%>
                </td>

                <td>

                    <strong>
                        <%=producto.get("nombre")%>
                    </strong>

                </td>

                <td>
                    <%=producto.get("categoria")%>
                </td>

                <td>
                    <%=producto.get("marca")%>
                </td>

                <td>
                    <%=producto.get("cantidad")%>
                </td>

                <td>
                    <%=producto.get("stockMinimo")%>
                </td>

                <td>

                    <%=moneda.format(
                        ((Number)producto.get("precioVenta"))
                        .doubleValue()
                    )%>

                </td>

                <td>

                    <%
                        String estadoProducto =
                                String.valueOf(
                                    producto.get("estado")
                                ).toUpperCase();

                        String claseProducto =
                                estadoProducto.equals("ACTIVO")
                                ? "badge-success"
                                : "badge-warning";
                    %>

                    <span class="badge <%=claseProducto%>">

                        <%=estadoProducto%>

                    </span>

                </td>

            </tr>


            <% } %>


            </tbody>

        </table>

    </div>

</div>


</section>

</main>

</div>



<script>

lucide.createIcons();


/* =========================================================
   DATOS DEL GRÁFICO
   ========================================================= */

const etiquetas = [

<%
    for(Map<String,Object> venta : ventas) {

        Object fecha =
                venta.get("fecha");

        String fechaTexto =
                fecha == null
                ? ""
                : fecha.toString();

        out.print(
            "'" +
            fechaTexto.replace("'","") +
            "',"
        );
    }
%>

];


const valores = [

<%
    for(Map<String,Object> venta : ventas) {

        Object total =
                venta.get("totalVentas");

        out.print(
            total == null
            ? "0,"
            : total.toString() + ","
        );
    }
%>

];


const ctx =
    document.getElementById(
        "ventasChart"
    );


if(ctx) {

    new Chart(ctx, {

        type: "line",

        data: {

            labels: etiquetas,

            datasets: [{

                label: "Ventas",

                data: valores,

                borderWidth: 3,

                tension: .35,

                fill: true,

                pointRadius: 4,

                pointHoverRadius: 6

            }]

        },


        options: {

            responsive: true,

            maintainAspectRatio: false,

            plugins: {

                legend: {

                    display: false

                },

                tooltip: {

                    callbacks: {

                        label: function(context) {

                            return "Ventas: $" +
                                Number(
                                    context.raw || 0
                                ).toLocaleString(
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

</html>