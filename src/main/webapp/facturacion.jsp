<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mycompany.sigtal.modelo.Cliente"%>
<%@page import="com.mycompany.sigtal.modelo.Vehiculo"%>
<%@page import="com.mycompany.sigtal.modelo.Producto"%>

<%
    List<Cliente> clientes =
            (List<Cliente>) request.getAttribute("clientes");

    List<Producto> productos =
            (List<Producto>) request.getAttribute("productos");

    List<Vehiculo> vehiculos =
            (List<Vehiculo>) request.getAttribute("vehiculos");

    List<Map<String, Object>> facturasBuscadas =
            (List<Map<String, Object>>)
            request.getAttribute("facturasBuscadas");

    // Factura guardada seleccionada para ver/imprimir
    Map<String, Object> facturaSeleccionada =
            (Map<String, Object>) request.getAttribute("facturaSeleccionada");

    List<Map<String, Object>> detallesSeleccionados =
            (List<Map<String, Object>>) request.getAttribute("detallesSeleccionados");

    Boolean imprimirFacturaGuardada =
            (Boolean) request.getAttribute("imprimirFacturaGuardada");

    Integer clienteSeleccionado =
            (Integer) request.getAttribute(
                    "clienteSeleccionado"
            );

    Cliente clienteSeleccionadoObjeto =
            (Cliente) request.getAttribute(
                    "clienteSeleccionadoObjeto"
            );

    String numeroFactura =
            (String) request.getAttribute(
                    "numeroFactura"
            );

    String mensaje =
            (String) request.getAttribute(
                    "mensaje"
            );

    String error =
            (String) request.getAttribute(
                    "error"
            );

    String busqueda =
            (String) request.getAttribute(
                    "busqueda"
            );

    String estadoBusqueda =
            (String) request.getAttribute(
                    "estadoBusqueda"
            );

    String fechaDesde =
            (String) request.getAttribute(
                    "fechaDesde"
            );

    String fechaHasta =
            (String) request.getAttribute(
                    "fechaHasta"
            );

    if (numeroFactura == null
            || numeroFactura.isBlank()) {

        numeroFactura =
                "Se generará al guardar";
    }

    if (busqueda == null) {
        busqueda = "";
    }

    if (estadoBusqueda == null
            || estadoBusqueda.isBlank()) {

        estadoBusqueda = "TODOS";
    }

    if (fechaDesde == null) {
        fechaDesde = "";
    }

    if (fechaHasta == null) {
        fechaHasta = "";
    }

    String nombreCliente = "";
    String documentoCliente = "";
    String telefonoCliente = "";
    String correoCliente = "";
    String direccionCliente = "";

    if (clienteSeleccionadoObjeto != null) {

        nombreCliente =
                clienteSeleccionadoObjeto.getNombre();

        documentoCliente =
                clienteSeleccionadoObjeto.getDocumento();

        telefonoCliente =
                clienteSeleccionadoObjeto.getTelefono();

        correoCliente =
                clienteSeleccionadoObjeto.getCorreo();

        direccionCliente =
                clienteSeleccionadoObjeto.getDireccion();
    }

    SimpleDateFormat formatoFecha =
            new SimpleDateFormat(
                    "dd/MM/yyyy HH:mm"
            );
%>


<%!
    public String escaparHTML(String texto) {

        if (texto == null) {
            return "";
        }

        return texto
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }


    public String moneda(Object valor) {

        if (valor == null) {
            return "$0";
        }

        try {

            java.math.BigDecimal numero =
                    new java.math.BigDecimal(
                            valor.toString()
                    );

            return java.text.NumberFormat
                    .getCurrencyInstance(
                            new java.util.Locale(
                                    "es",
                                    "CO"
                            )
                    )
                    .format(numero);

        } catch (Exception e) {

            return "$0";
        }
    }
%>


<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>
        Facturación | SIGTAL
    </title>


    <style>

        * {
            box-sizing: border-box;
        }


        body {

            margin: 0;

            font-family:
                "Segoe UI",
                Arial,
                sans-serif;

            background: #f1f5f9;

            color: #1e293b;
        }


        .contenedor {

            max-width: 1450px;

            margin: 0 auto;

            padding: 25px;
        }


        .encabezado {

            background:
                linear-gradient(
                    135deg,
                    #0f172a,
                    #1e3a8a
                );

            color: white;

            border-radius: 18px;

            padding: 25px 30px;

            margin-bottom: 20px;

            box-shadow:
                0 10px 30px
                rgba(
                    15,
                    23,
                    42,
                    .15
                );
        }


        .encabezado h1 {

            margin: 0 0 7px;

            font-size: 28px;
        }


        .encabezado p {

            margin: 0;

            opacity: .85;
        }


        .barra-acciones {

            display: flex;

            justify-content: space-between;

            align-items: center;

            gap: 15px;

            flex-wrap: wrap;

            margin-bottom: 25px;
        }


        .alerta {

            padding: 15px 18px;

            border-radius: 12px;

            margin-bottom: 20px;

            font-weight: 600;
        }


        .alerta.exito {

            background: #dcfce7;

            color: #166534;

            border:
                1px solid #86efac;
        }


        .alerta.error {

            background: #fee2e2;

            color: #991b1b;

            border:
                1px solid #fca5a5;
        }


        .grid-principal {

            display: grid;

            grid-template-columns:
                minmax(0, 1fr)
                380px;

            gap: 25px;

            align-items: start;
        }


        .card {

            background: white;

            border-radius: 18px;

            padding: 25px;

            margin-bottom: 25px;

            box-shadow:
                0 6px 22px
                rgba(
                    15,
                    23,
                    42,
                    .08
                );

            border:
                1px solid #e2e8f0;
        }


        .titulo-card {

            display: flex;

            align-items: center;

            gap: 10px;

            margin:
                0 0 22px;

            font-size: 19px;

            color: #0f172a;
        }


        .titulo-card span {

            font-size: 23px;
        }


        .grid-formulario {

            display: grid;

            grid-template-columns:
                repeat(
                    2,
                    minmax(0, 1fr)
                );

            gap: 18px;
        }


        .campo {

            display: flex;

            flex-direction: column;

            gap: 7px;
        }


        .campo-completo {

            grid-column: 1 / -1;
        }


        label {

            font-size: 14px;

            font-weight: 700;

            color: #334155;
        }


        input,
        select {

            width: 100%;

            padding: 12px 14px;

            border:
                1px solid #cbd5e1;

            border-radius: 10px;

            font-size: 14px;

            background: white;

            color: #0f172a;

            outline: none;

            transition: .2s;
        }


        input:focus,
        select:focus {

            border-color: #2563eb;

            box-shadow:
                0 0 0 3px
                rgba(
                    37,
                    99,
                    235,
                    .12
                );
        }


        input[readonly] {

            background: #f8fafc;
        }


        .numero-factura {

            font-size: 18px;

            font-weight: 800;

            color: #1d4ed8;

            background: #eff6ff !important;

            border-color: #bfdbfe;
        }


        .datos-box {

            margin-top: 20px;

            padding: 18px;

            border-radius: 14px;

            background: #f8fafc;

            border:
                1px solid #e2e8f0;
        }


        .datos-grid {

            display: grid;

            grid-template-columns:
                repeat(
                    2,
                    minmax(0, 1fr)
                );

            gap: 14px;
        }


        .dato {

            background: white;

            border-radius: 10px;

            padding: 12px 14px;

            border:
                1px solid #e2e8f0;
        }


        .dato strong {

            display: block;

            font-size: 12px;

            color: #64748b;

            margin-bottom: 4px;
        }


        .dato span {

            font-size: 14px;

            font-weight: 600;

            color: #0f172a;

            word-break: break-word;
        }


        .producto-selector {

            background: #f8fafc;

            border:
                1px solid #e2e8f0;

            border-radius: 14px;

            padding: 18px;

            margin-bottom: 20px;
        }


        .producto-info {

            display: grid;

            grid-template-columns:
                1fr 1fr;

            gap: 15px;

            margin-top: 15px;
        }


        .botones {

            display: flex;

            flex-wrap: wrap;

            gap: 10px;
        }


        .boton {

            border: none;

            border-radius: 10px;

            padding:
                12px 18px;

            cursor: pointer;

            font-weight: 700;

            font-size: 14px;

            transition: .2s;

            text-decoration: none;

            display: inline-flex;

            align-items: center;

            justify-content: center;
        }


        .boton:hover {

            transform:
                translateY(-1px);
        }


        .boton-azul {

            background: #2563eb;

            color: white;
        }


        .boton-verde {

            background: #16a34a;

            color: white;
        }


        .boton-rojo {

            background: #dc2626;

            color: white;
        }


        .boton-gris {

            background: #64748b;

            color: white;
        }


        .boton-negro {

            background: #0f172a;

            color: white;
        }


        .boton-whatsapp {

            background: #25d366;

            color: white;
        }


        .boton-buscar {

            background: #1d4ed8;

            color: white;

            font-size: 15px;
        }


        .tabla-contenedor {

            overflow-x: auto;
        }


        table {

            width: 100%;

            border-collapse:
                collapse;

            min-width: 850px;
        }


        th {

            background: #0f172a;

            color: white;

            padding: 13px;

            text-align: left;

            font-size: 13px;
        }


        td {

            padding: 12px;

            border-bottom:
                1px solid #e2e8f0;

            font-size: 14px;
        }


        tbody tr:hover {

            background: #f8fafc;
        }


        .sin-datos {

            text-align: center;

            padding: 35px;

            color: #64748b;
        }


        .acciones-detalle {

            text-align: center;
        }


        .boton-eliminar {

            border: none;

            background: #fee2e2;

            color: #b91c1c;

            width: 34px;

            height: 34px;

            border-radius: 8px;

            cursor: pointer;

            font-weight: bold;
        }


        .resumen {

            position: sticky;

            top: 20px;
        }


        .resumen-linea {

            display: flex;

            justify-content:
                space-between;

            gap: 15px;

            padding: 12px 0;

            border-bottom:
                1px solid #e2e8f0;
        }


        .resumen-linea span:first-child {

            color: #64748b;
        }


        .resumen-linea strong {

            color: #0f172a;
        }


        .total-final {

            display: flex;

            justify-content:
                space-between;

            align-items: center;

            margin-top: 15px;

            padding: 18px;

            border-radius: 14px;

            background: #eff6ff;

            border:
                1px solid #bfdbfe;
        }


        .total-final span {

            font-size: 17px;

            font-weight: 700;
        }


        .total-final strong {

            font-size: 25px;

            color: #1d4ed8;
        }


        .acciones-finales {

            display: flex;

            flex-direction: column;

            gap: 10px;

            margin-top: 20px;
        }


        .acciones-finales .boton {

            width: 100%;
        }


        .badge {

            display: inline-block;

            padding:
                5px 9px;

            border-radius: 999px;

            background: #dbeafe;

            color: #1d4ed8;

            font-size: 11px;

            font-weight: 700;
        }


        .badge-pagada {

            background: #dcfce7;

            color: #166534;
        }


        .badge-pendiente {

            background: #fef3c7;

            color: #92400e;
        }


        .badge-anulada {

            background: #fee2e2;

            color: #991b1b;
        }


        .busqueda-grid {

            display: grid;

            grid-template-columns:
                2fr
                1fr
                1fr
                1fr;

            gap: 15px;

            align-items: end;
        }


        .resultado-info {

            display: flex;

            justify-content:
                space-between;

            align-items: center;

            flex-wrap: wrap;

            gap: 10px;

            margin-bottom: 15px;

            color: #475569;
        }


        .contador {

            background: #eff6ff;

            color: #1d4ed8;

            padding:
                7px 12px;

            border-radius: 999px;

            font-weight: 700;

            font-size: 13px;
        }


        .acciones-tabla {

            display: flex;

            gap: 6px;

            flex-wrap: wrap;
        }


        .boton-tabla {

            border: none;

            border-radius: 7px;

            padding:
                7px 9px;

            cursor: pointer;

            font-size: 12px;

            font-weight: 700;
        }


        .ver {

            background: #dbeafe;

            color: #1d4ed8;
        }


        .eliminar {

            background: #fee2e2;

            color: #b91c1c;
        }


        .servicio-box {

            margin-top: 18px;

            padding: 15px;

            background: #fff7ed;

            border:
                1px solid #fed7aa;

            border-radius: 12px;
        }


        .servicio-box p {

            margin:
                0 0 12px;

            color: #9a3412;

            font-size: 13px;
        }


        .vehiculo-vacio {

            padding: 15px;

            margin-top: 15px;

            border-radius: 10px;

            background: #fff7ed;

            color: #9a3412;

            border:
                1px solid #fed7aa;
        }


        #facturaImpresion {
            display: none;
        }


        @media(max-width: 1100px) {

            .busqueda-grid {

                grid-template-columns:
                    1fr 1fr;
            }
        }


        @media(max-width: 1000px) {

            .grid-principal {

                grid-template-columns:
                    1fr;
            }

            .resumen {

                position: static;
            }
        }


        @media(max-width: 700px) {

            .contenedor {

                padding: 12px;
            }

            .grid-formulario,
            .datos-grid,
            .producto-info,
            .busqueda-grid {

                grid-template-columns:
                    1fr;
            }

            .campo-completo {

                grid-column: auto;
            }

            .card {

                padding: 18px;
            }

            .encabezado {

                padding: 20px;
            }
        }



        /* ======================================================
           FACTURA GUARDADA
           ====================================================== */

        .factura-guardada {
            border: 2px solid #bfdbfe;
            background: #ffffff;
        }

        .factura-guardada-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e2e8f0;
        }

        .factura-guardada-header h2 {
            margin: 0 0 5px;
            color: #0f172a;
        }

        .factura-numero-grande {
            font-size: 22px;
            font-weight: 800;
            color: #1d4ed8;
        }

        .factura-guardada-datos {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 20px;
        }

        .factura-guardada-datos .dato {
            min-height: 68px;
        }

        .tabla-factura-guardada {
            overflow-x: auto;
            margin-top: 15px;
        }

        .tabla-factura-guardada table {
            min-width: 700px;
        }

        .totales-guardada {
            margin-left: auto;
            width: min(420px, 100%);
            margin-top: 20px;
        }

        .totales-guardada .total-final {
            margin-top: 10px;
        }

        .acciones-guardada {
            display: flex;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 20px;
        }

        .imprimir {
            background: #e0e7ff;
            color: #3730a3;
        }

        .enviar {
            background: #dcfce7;
            color: #166534;
        }

        .acciones-tabla form {
            display: inline;
            margin: 0;
            padding: 0;
        }

        .acciones-tabla .boton-tabla {
            white-space: nowrap;
        }

        @media print {

            @page {
                size: Letter portrait;
                margin: 7mm;
            }

            html,
            body {
                width: 100% !important;
                height: auto !important;
                min-height: 0 !important;
                margin: 0 !important;
                padding: 0 !important;
                background: #ffffff !important;
                overflow: visible !important;
            }

            /* En impresión solo existe la plantilla de factura */
            body > * {
                display: none !important;
            }

            body > #facturaImpresion {
                display: block !important;
                position: static !important;
                width: 100% !important;
                height: auto !important;
                min-height: 0 !important;
                max-height: none !important;
                margin: 0 !important;
                padding: 0 !important;
                background: #ffffff !important;
                color: #111827 !important;
                overflow: visible !important;
                break-before: auto !important;
                break-after: avoid !important;
                page-break-before: auto !important;
                page-break-after: avoid !important;
            }

            /* Evitar páginas adicionales por elementos internos */
            #facturaImpresion,
            #facturaImpresion * {
                box-sizing: border-box !important;
            }

            #facturaImpresion * {
                break-before: auto !important;
                page-break-before: auto !important;
            }

            #facturaImpresion .factura-print-header,
            #facturaImpresion .datos-doble-print,
            #facturaImpresion .detalle-print,
            #facturaImpresion .zona-totales-print,
            #facturaImpresion .footer-factura-print {
                break-inside: avoid !important;
                page-break-inside: avoid !important;
            }

            #facturaGuardada,
            .contenedor,
            button,
            .boton,
            .acciones-guardada,
            .acciones-tabla,
            nav,
            aside,
            form {
                display: none !important;
            }

            .factura-print-header {
                display: grid;
                grid-template-columns: 1fr 245px;
                gap: 15px;
                align-items: stretch;
                padding-bottom: 10px;
                border-bottom: 2px solid #1e5a8a;
            }

            .taller-identidad-print {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .logo-taller-print {
                width: 58px;
                height: 58px;
                border: 2px solid #1e5a8a;
                border-radius: 9px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 28px;
                flex-shrink: 0;
            }

            .taller-identidad-print h1 {
                margin: 0 0 3px;
                font-size: 22px;
                font-weight: 800;
            }

            .taller-identidad-print p {
                margin: 2px 0;
                font-size: 9px;
            }

            .factura-caja-print {
                border: 1px solid #9ca3af;
                border-radius: 6px;
                overflow: hidden;
                text-align: center;
            }

            .factura-caja-print h2 {
                margin: 0;
                padding: 6px;
                background: #e5e7eb;
                font-size: 13px;
            }

            .numero-print {
                padding: 6px 4px 3px;
                font-size: 18px;
                font-weight: 800;
            }

            .estado-print {
                padding: 3px;
                font-size: 9px;
                border-top: 1px solid #d1d5db;
            }

            .fecha-print {
                padding: 3px 4px 6px;
                font-size: 8px;
            }

            .datos-doble-print {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 10px;
                margin-top: 10px;
            }

            .bloque-print {
                border: 1px solid #9ca3af;
                border-radius: 6px;
                overflow: hidden;
            }

            .titulo-bloque-print {
                padding: 5px 8px;
                background: #e5e7eb;
                font-size: 10px;
                font-weight: 800;
            }

            .fila-print {
                display: grid;
                grid-template-columns: 70px 1fr;
                padding: 3px 7px;
                border-top: 1px solid #e5e7eb;
                font-size: 8.5px;
                min-height: 19px;
            }

            .detalle-print {
                margin-top: 10px;
            }

            .titulo-detalle-print {
                padding: 6px 8px;
                background: #1e5a8a;
                color: #ffffff;
                font-size: 10px;
                font-weight: 800;
                border-radius: 6px 6px 0 0;
            }

            #tablaImpresion {
                width: 100% !important;
                min-width: 0 !important;
                border-collapse: collapse;
                font-size: 8px;
            }

            #tablaImpresion th {
                background: #e5e7eb !important;
                color: #111827 !important;
                border: 1px solid #9ca3af;
                padding: 5px 3px;
                text-align: center;
                font-size: 8px;
            }

            #tablaImpresion td {
                border: 1px solid #d1d5db;
                padding: 5px 3px;
                text-align: center;
                font-size: 8px;
            }

            #tablaImpresion td:nth-child(3) {
                text-align: left;
            }

            .zona-totales-print {
                display: grid;
                grid-template-columns: 1fr 260px;
                gap: 12px;
                margin-top: 10px;
                align-items: start;
            }

            .observaciones-print {
                border: 1px solid #d1d5db;
                border-radius: 6px;
                padding: 8px;
                min-height: 62px;
                font-size: 8.5px;
            }

            .observaciones-print strong {
                font-size: 10px;
            }

            .observaciones-print p {
                margin: 5px 0 0;
            }

            .print-resumen {
                width: 100% !important;
                margin: 0 !important;
                border: 1px solid #9ca3af;
                border-radius: 6px;
                overflow: hidden;
            }

            .print-resumen div {
                display: flex;
                justify-content: space-between;
                padding: 5px 8px;
                border-bottom: 1px solid #d1d5db;
                font-size: 9px;
            }

            .print-resumen .print-total {
                background: #1e5a8a;
                color: #ffffff;
                font-size: 13px;
                font-weight: 800;
                border-bottom: none;
            }

            .footer-factura-print {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 2px;
                margin-top: 10px;
                padding-top: 6px;
                border-top: 1px solid #1e5a8a;
                text-align: center;
                font-size: 7.5px;
            }

            .footer-factura-print strong {
                font-size: 9px;
            }

            .footer-factura-print em {
                margin-top: 2px;
                font-size: 8px;
            }
        }

    </style>

</head>


<body>


<div class="contenedor">


    <!-- ======================================================
         ENCABEZADO
         ====================================================== -->

    <div class="encabezado">

        <h1>
            📄 Facturación
        </h1>

        <p>
            Gestión de facturas, productos y servicios
            del taller automotriz Electricista Londoño.
        </p>

    </div>


    <!-- ======================================================
         BOTÓN BUSCAR
         ====================================================== -->

    <div class="barra-acciones">

        <div>

            <strong>
                Gestión de facturas
            </strong>

            <div style="color:#64748b;margin-top:4px;">

                Registre nuevas facturas o consulte
                las facturas guardadas.

            </div>

        </div>


        <button
            type="button"
            class="boton boton-buscar"
            onclick="mostrarBuscador()"
        >

            🔎 Buscar facturas

        </button>

    </div>


    <!-- ======================================================
         MENSAJES
         ====================================================== -->

    <% if (mensaje != null
            && !mensaje.isBlank()) { %>

        <div class="alerta exito">

            ✅
            <%= escaparHTML(mensaje) %>

        </div>

    <% } %>


    <% if (error != null
            && !error.isBlank()) { %>

        <div class="alerta error">

            ❌
            <%= escaparHTML(error) %>

        </div>

    <% } %>


    <!-- ======================================================
         BUSCADOR DE FACTURAS
         ====================================================== -->

    <div
        class="card"
        id="seccionBuscador"
        style="display:none;"
    >

        <h2 class="titulo-card">

            <span>🔎</span>

            Buscar facturas guardadas

        </h2>


        <form
            method="GET"
            action="<%= request.getContextPath() %>/facturacion"
        >

            <input
                type="hidden"
                name="accion"
                value="buscarFacturas"
            >


            <div class="busqueda-grid">


                <div class="campo">

                    <label for="busqueda">

                        Número, cliente o documento

                    </label>

                    <input
                        type="text"
                        id="busqueda"
                        name="busqueda"
                        value="<%= escaparHTML(busqueda) %>"
                        placeholder="Ej: FAC-000001, Juan, 123456789"
                    >

                </div>


                <div class="campo">

                    <label for="estadoBusqueda">

                        Estado

                    </label>

                    <select
                        id="estadoBusqueda"
                        name="estadoBusqueda"
                    >

                        <option
                            value="TODOS"
                            <%= "TODOS".equalsIgnoreCase(
                                    estadoBusqueda)
                                    ? "selected"
                                    : "" %>
                        >
                            Todos
                        </option>

                        <option
                            value="PENDIENTE"
                            <%= "PENDIENTE".equalsIgnoreCase(
                                    estadoBusqueda)
                                    ? "selected"
                                    : "" %>
                        >
                            Pendiente
                        </option>

                        <option
                            value="PAGADA"
                            <%= "PAGADA".equalsIgnoreCase(
                                    estadoBusqueda)
                                    ? "selected"
                                    : "" %>
                        >
                            Pagada
                        </option>

                        <option
                            value="ANULADA"
                            <%= "ANULADA".equalsIgnoreCase(
                                    estadoBusqueda)
                                    ? "selected"
                                    : "" %>
                        >
                            Anulada
                        </option>

                    </select>

                </div>


                <div class="campo">

                    <label for="fechaDesde">

                        Desde

                    </label>

                    <input
                        type="date"
                        id="fechaDesde"
                        name="fechaDesde"
                        value="<%= escaparHTML(fechaDesde) %>"
                    >

                </div>


                <div class="campo">

                    <label for="fechaHasta">

                        Hasta

                    </label>

                    <input
                        type="date"
                        id="fechaHasta"
                        name="fechaHasta"
                        value="<%= escaparHTML(fechaHasta) %>"
                    >

                </div>


            </div>


            <div
                class="botones"
                style="margin-top:18px;"
            >

                <button
                    type="submit"
                    class="boton boton-azul"
                >

                    🔎 Buscar

                </button>


                <a
                    href="<%= request.getContextPath() %>/facturacion"
                    class="boton boton-gris"
                >

                    🔄 Limpiar búsqueda

                </a>

            </div>

        </form>

    </div>


    <!-- ======================================================
         RESULTADOS
         ====================================================== -->

    <% if (facturasBuscadas != null) { %>

        <div class="card">

            <div class="resultado-info">

                <div>

                    <h2
                        class="titulo-card"
                        style="margin-bottom:5px;"
                    >

                        <span>📋</span>

                        Facturas encontradas

                    </h2>

                    <span>

                        Resultados de la consulta realizada.

                    </span>

                </div>


                <div class="contador">

                    <%= facturasBuscadas.size() %>
                    factura(s)

                </div>

            </div>


            <div class="tabla-contenedor">

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
                                Documento
                            </th>

                            <th>
                                Vehículo
                            </th>

                            <th>
                                Total
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


                    <% if (facturasBuscadas.isEmpty()) { %>

                        <tr>

                            <td
                                colspan="8"
                                class="sin-datos"
                            >

                                🔍

                                No se encontraron
                                facturas con los
                                criterios seleccionados.

                            </td>

                        </tr>

                    <% } else { %>


                        <% for (
                            Map<String,Object> factura :
                            facturasBuscadas
                        ) { %>


                            <%
                                Object fechaObjeto =
                                        factura.get(
                                                "fechaFactura"
                                        );

                                String fechaTexto = "-";

                                if (fechaObjeto
                                        instanceof java.util.Date) {

                                    fechaTexto =
                                            formatoFecha.format(
                                                    fechaObjeto
                                            );
                                }

                                String estado =
                                        factura.get(
                                                "estado"
                                        ) == null
                                        ? ""
                                        : factura.get(
                                                "estado"
                                        ).toString();

                                String claseEstado =
                                        "";

                                if ("PAGADA".equalsIgnoreCase(
                                        estado)) {

                                    claseEstado =
                                            "badge-pagada";

                                } else if (
                                        "ANULADA".equalsIgnoreCase(
                                                estado)) {

                                    claseEstado =
                                            "badge-anulada";

                                } else {

                                    claseEstado =
                                            "badge-pendiente";
                                }

                                String placa =
                                        factura.get(
                                                "placaVehiculo"
                                        ) == null
                                        ? "-"
                                        : factura.get(
                                                "placaVehiculo"
                                        ).toString();

                                String marca =
                                        factura.get(
                                                "marcaVehiculo"
                                        ) == null
                                        ? ""
                                        : factura.get(
                                                "marcaVehiculo"
                                        ).toString();

                                String modelo =
                                        factura.get(
                                                "modeloVehiculo"
                                        ) == null
                                        ? ""
                                        : factura.get(
                                                "modeloVehiculo"
                                        ).toString();
                            %>


                            <tr>


                                <td>

                                    <strong>

                                        <%= escaparHTML(
                                                String.valueOf(
                                                    factura.get(
                                                        "numeroFactura"
                                                    )
                                                )
                                        ) %>

                                    </strong>

                                </td>


                                <td>

                                    <%= escaparHTML(
                                            fechaTexto
                                    ) %>

                                </td>


                                <td>

                                    <%= escaparHTML(
                                            String.valueOf(
                                                factura.get(
                                                    "nombreCliente"
                                                )
                                            )
                                    ) %>

                                </td>


                                <td>

                                    <%= escaparHTML(
                                            String.valueOf(
                                                factura.get(
                                                    "documentoCliente"
                                                )
                                            )
                                    ) %>

                                </td>


                                <td>

                                    <strong>
                                        <%= escaparHTML(
                                                placa
                                        ) %>
                                    </strong>

                                    <% if (!marca.isBlank()) { %>

                                        <br>

                                        <small>

                                            <%= escaparHTML(
                                                    marca
                                            ) %>

                                            <%= escaparHTML(
                                                    modelo
                                            ) %>

                                        </small>

                                    <% } %>

                                </td>


                                <td>

                                    <strong>

                                        <%= moneda(
                                                factura.get(
                                                    "total"
                                                )
                                        ) %>

                                    </strong>

                                </td>


                                <td>

                                    <span
                                        class="badge <%= claseEstado %>"
                                    >

                                        <%= escaparHTML(
                                                estado
                                        ) %>

                                    </span>

                                </td>


                                <td>

                                    <div class="acciones-tabla">

                                        <!-- VER -->
                                        <button
                                            type="button"
                                            class="boton-tabla ver"
                                            onclick="verFactura(<%= factura.get("idFactura") %>)"
                                            title="Ver factura"
                                        >
                                            👁️ Ver
                                        </button>

                                        <!-- IMPRIMIR -->
                                        <button
                                            type="button"
                                            class="boton-tabla imprimir"
                                            onclick="imprimirFacturaGuardada(<%= factura.get("idFactura") %>)"
                                            title="Imprimir factura"
                                        >
                                            🖨️ Imprimir
                                        </button>

                                        <!-- ENVIAR POR WHATSAPP -->
                                        <button
                                            type="button"
                                            class="boton-tabla enviar"
                                            onclick="enviarFacturaGuardada(this)"
                                            data-telefono="<%= escaparHTML(factura.get("telefonoCliente") == null ? "" : factura.get("telefonoCliente").toString()) %>"
                                            data-cliente="<%= escaparHTML(factura.get("nombreCliente") == null ? "Cliente" : factura.get("nombreCliente").toString()) %>"
                                            data-factura="<%= escaparHTML(factura.get("numeroFactura") == null ? "" : factura.get("numeroFactura").toString()) %>"
                                            data-total="<%= escaparHTML(moneda(factura.get("total"))) %>"
                                            data-estado="<%= escaparHTML(factura.get("estado") == null ? "" : factura.get("estado").toString()) %>"
                                            title="Enviar por WhatsApp"
                                        >
                                            📤 Enviar
                                        </button>

                                        <!-- ELIMINAR -->
                                        <form
                                            method="POST"
                                            action="<%= request.getContextPath() %>/facturacion"
                                            onsubmit="return confirmarEliminarFactura();"
                                        >
                                            <input
                                                type="hidden"
                                                name="accion"
                                                value="eliminar"
                                            >
                                            <input
                                                type="hidden"
                                                name="idFactura"
                                                value="<%= factura.get("idFactura") %>"
                                            >
                                            <button
                                                type="submit"
                                                class="boton-tabla eliminar"
                                                title="Eliminar factura"
                                            >
                                                🗑️ Eliminar
                                            </button>
                                        </form>

                                    </div>

                                </td>


                            </tr>


                        <% } %>


                    <% } %>


                    </tbody>

                </table>

            </div>

        </div>

    <% } %>


    <!-- ======================================================
         FACTURA GUARDADA SELECCIONADA
         ====================================================== -->

    <% if (facturaSeleccionada != null) { %>

        <div class="card factura-guardada" id="facturaGuardada">

            <div class="factura-guardada-header">
                <div>
                    <h2>🧾 Factura guardada</h2>
                    <div class="factura-numero-grande">
                        <%= escaparHTML(String.valueOf(facturaSeleccionada.get("numeroFactura"))) %>
                    </div>
                </div>

                <div class="acciones-guardada">
                    <button
                        type="button"
                        class="boton boton-negro"
                        onclick="imprimirFacturaGuardada(<%= facturaSeleccionada.get("idFactura") %>)"
                    >
                        🖨️ Imprimir
                    </button>
                    <button
                        type="button"
                        class="boton boton-gris"
                        onclick="cerrarFacturaGuardada()"
                    >
                        ✖️ Cerrar
                    </button>
                </div>
            </div>

            <div class="factura-guardada-datos">
                <div class="dato">
                    <strong>Fecha</strong>
                    <span>
                        <%= escaparHTML(String.valueOf(facturaSeleccionada.get("fechaFactura"))) %>
                    </span>
                </div>
                <div class="dato">
                    <strong>Estado</strong>
                    <span>
                        <%= escaparHTML(String.valueOf(facturaSeleccionada.get("estado"))) %>
                    </span>
                </div>
                <div class="dato">
                    <strong>Cliente</strong>
                    <span>
                        <%= escaparHTML(String.valueOf(facturaSeleccionada.get("nombreCliente"))) %>
                    </span>
                </div>
                <div class="dato">
                    <strong>Documento</strong>
                    <span>
                        <%= escaparHTML(String.valueOf(facturaSeleccionada.get("documentoCliente"))) %>
                    </span>
                </div>
                <div class="dato">
                    <strong>Teléfono</strong>
                    <span>
                        <%= escaparHTML(String.valueOf(facturaSeleccionada.get("telefonoCliente"))) %>
                    </span>
                </div>
                <div class="dato">
                    <strong>Correo</strong>
                    <span>
                        <%= escaparHTML(String.valueOf(facturaSeleccionada.get("correoCliente"))) %>
                    </span>
                </div>
                <div class="dato">
                    <strong>Vehículo</strong>
                    <span>
                        <%= escaparHTML(String.valueOf(facturaSeleccionada.get("placaVehiculo"))) %>
                        <% if (facturaSeleccionada.get("marcaVehiculo") != null) { %>
                            — <%= escaparHTML(String.valueOf(facturaSeleccionada.get("marcaVehiculo"))) %>
                            <%= escaparHTML(String.valueOf(facturaSeleccionada.get("modeloVehiculo"))) %>
                        <% } %>
                    </span>
                </div>
                <div class="dato">
                    <strong>Dirección</strong>
                    <span>
                        <%= escaparHTML(String.valueOf(facturaSeleccionada.get("direccionCliente"))) %>
                    </span>
                </div>
            </div>

            <h3 class="titulo-card">
                <span>📦</span> Detalle de la factura
            </h3>

            <div class="tabla-factura-guardada">
                <table>
                    <thead>
                        <tr>
                            <th>Tipo</th>
                            <th>Código</th>
                            <th>Descripción</th>
                            <th>Cantidad</th>
                            <th>Precio unitario</th>
                            <th>Descuento</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (detallesSeleccionados != null && !detallesSeleccionados.isEmpty()) { %>
                            <% for (Map<String,Object> detalle : detallesSeleccionados) { %>
                                <tr>
                                    <td>
                                        <%= detalle.get("idProducto") == null ? "Servicio" : "Producto" %>
                                    </td>
                                    <td>
                                        <%= escaparHTML(detalle.get("codigo") == null ? "-" : detalle.get("codigo").toString()) %>
                                    </td>
                                    <td>
                                        <%= escaparHTML(detalle.get("descripcion") == null ? "-" : detalle.get("descripcion").toString()) %>
                                    </td>
                                    <td><%= detalle.get("cantidad") == null ? "0" : detalle.get("cantidad") %></td>
                                    <td><%= moneda(detalle.get("precioUnitario")) %></td>
                                    <td><%= moneda(detalle.get("descuento")) %></td>
                                    <td><strong><%= moneda(detalle.get("subtotal")) %></strong></td>
                                </tr>
                            <% } %>
                        <% } else { %>
                            <tr>
                                <td colspan="7" class="sin-datos">
                                    No hay detalles registrados para esta factura.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="totales-guardada">
                <div class="resumen-linea">
                    <span>Subtotal</span>
                    <strong><%= moneda(facturaSeleccionada.get("subtotal")) %></strong>
                </div>
                <div class="resumen-linea">
                    <span>Descuento</span>
                    <strong><%= moneda(facturaSeleccionada.get("descuento")) %></strong>
                </div>
                <div class="resumen-linea">
                    <span>Impuesto</span>
                    <strong><%= moneda(facturaSeleccionada.get("impuesto")) %></strong>
                </div>
                <div class="total-final">
                    <span>Total</span>
                    <strong><%= moneda(facturaSeleccionada.get("total")) %></strong>
                </div>
            </div>

        </div>

    <% } %>


    <!-- ======================================================
         FORMULARIO PRINCIPAL
         ====================================================== -->

    <form
        id="formFactura"
        method="POST"
        action="<%= request.getContextPath() %>/facturacion"
        onsubmit="return prepararFactura();"
    >

        <input
            type="hidden"
            name="accion"
            value="registrar"
        >


        <div class="grid-principal">


            <div>


                <!-- INFORMACIÓN -->

                <div class="card">

                    <h2 class="titulo-card">

                        <span>🧾</span>

                        Información de la factura

                    </h2>


                    <div class="grid-formulario">


                        <div class="campo">

                            <label>

                                Número de factura

                            </label>


                            <input
                                type="text"
                                id="numeroFactura"
                                class="numero-factura"
                                value="<%= escaparHTML(
                                        numeroFactura
                                ) %>"
                                readonly
                            >

                        </div>


                        <div class="campo">

                            <label for="estado">

                                Estado

                            </label>


                            <select
                                name="estado"
                                id="estado"
                            >

                                <option
                                    value="PENDIENTE"
                                >

                                    Pendiente

                                </option>

                                <option
                                    value="PAGADA"
                                >

                                    Pagada

                                </option>

                                <option
                                    value="ANULADA"
                                >

                                    Anulada

                                </option>

                            </select>

                        </div>


                        <!-- CLIENTE -->

                        <div
                            class="campo campo-completo"
                        >

                            <label for="idCliente">

                                Cliente *

                            </label>


                            <select
                                name="idCliente"
                                id="idCliente"
                                required
                                onchange="cargarCliente()"
                            >

                                <option value="">

                                    Seleccione un cliente

                                </option>


                                <%
                                    if (clientes != null) {

                                        for (
                                            Cliente cliente :
                                            clientes
                                        ) {

                                            boolean seleccionado =
                                                    clienteSeleccionado != null
                                                    && clienteSeleccionado
                                                    == cliente.getIdCliente();
                                %>


                                <option
                                    value="<%= cliente.getIdCliente() %>"
                                    <%= seleccionado
                                            ? "selected"
                                            : "" %>

                                    data-nombre="<%= escaparHTML(
                                            cliente.getNombre()
                                    ) %>"

                                    data-documento="<%= escaparHTML(
                                            cliente.getDocumento()
                                    ) %>"

                                    data-telefono="<%= escaparHTML(
                                            cliente.getTelefono()
                                    ) %>"

                                    data-correo="<%= escaparHTML(
                                            cliente.getCorreo()
                                    ) %>"

                                    data-direccion="<%= escaparHTML(
                                            cliente.getDireccion()
                                    ) %>"
                                >

                                    <%= escaparHTML(
                                            cliente.getNombre()
                                    ) %>

                                    -

                                    <%= escaparHTML(
                                            cliente.getDocumento()
                                    ) %>

                                </option>


                                <%
                                        }
                                    }
                                %>

                            </select>

                        </div>

                    </div>


                    <!-- DATOS CLIENTE -->

                    <div class="datos-box">

                        <h3 style="margin-top:0;">

                            👤 Información del cliente

                        </h3>


                        <div class="datos-grid">


                            <div class="dato">

                                <strong>
                                    Nombre
                                </strong>

                                <span id="clienteNombre">

                                    <%= nombreCliente == null
                                            || nombreCliente.isBlank()
                                            ? "-"
                                            : escaparHTML(
                                                nombreCliente
                                              ) %>

                                </span>

                            </div>


                            <div class="dato">

                                <strong>
                                    Documento
                                </strong>

                                <span id="clienteDocumento">

                                    <%= documentoCliente == null
                                            || documentoCliente.isBlank()
                                            ? "-"
                                            : escaparHTML(
                                                documentoCliente
                                              ) %>

                                </span>

                            </div>


                            <div class="dato">

                                <strong>
                                    Teléfono / WhatsApp
                                </strong>

                                <span id="clienteTelefono">

                                    <%= telefonoCliente == null
                                            || telefonoCliente.isBlank()
                                            ? "-"
                                            : escaparHTML(
                                                telefonoCliente
                                              ) %>

                                </span>

                            </div>


                            <div class="dato">

                                <strong>
                                    Correo
                                </strong>

                                <span id="clienteCorreo">

                                    <%= correoCliente == null
                                            || correoCliente.isBlank()
                                            ? "-"
                                            : escaparHTML(
                                                correoCliente
                                              ) %>

                                </span>

                            </div>


                            <div
                                class="dato"
                                style="grid-column:1/-1;"
                            >

                                <strong>
                                    Dirección
                                </strong>

                                <span id="clienteDireccion">

                                    <%= direccionCliente == null
                                            || direccionCliente.isBlank()
                                            ? "-"
                                            : escaparHTML(
                                                direccionCliente
                                              ) %>

                                </span>

                            </div>


                        </div>

                    </div>


                    <!-- VEHÍCULO -->

                    <div style="margin-top:25px;">

                        <div class="campo">

                            <label for="idVehiculo">

                                🚗 Vehículo

                            </label>


                            <select
                                name="idVehiculo"
                                id="idVehiculo"
                                onchange="actualizarVehiculo()"
                            >

                                <option value="0">

                                    Seleccione un vehículo

                                </option>


                                <%
                                    if (vehiculos != null
                                            && !vehiculos.isEmpty()) {

                                        for (
                                            Vehiculo vehiculo :
                                            vehiculos
                                        ) {
                                %>


                                <option
                                    value="<%= vehiculo.getIdVehiculo() %>"

                                    data-placa="<%= escaparHTML(
                                            vehiculo.getPlaca()
                                    ) %>"

                                    data-marca="<%= escaparHTML(
                                            vehiculo.getMarca()
                                    ) %>"

                                    data-modelo="<%= escaparHTML(
                                            vehiculo.getModelo()
                                    ) %>"

                                    data-anio="<%= vehiculo.getAnio()
                                            == null
                                            ? ""
                                            : vehiculo.getAnio() %>"

                                    data-color="<%= escaparHTML(
                                            vehiculo.getColor()
                                    ) %>"

                                    data-tipo="<%= escaparHTML(
                                            vehiculo.getTipoVehiculo()
                                    ) %>"
                                >

                                    <%= escaparHTML(
                                            vehiculo.getPlaca()
                                    ) %>

                                    -

                                    <%= escaparHTML(
                                            vehiculo.getMarca()
                                    ) %>

                                    <%= escaparHTML(
                                            vehiculo.getModelo()
                                    ) %>

                                </option>


                                <%
                                        }
                                    }
                                %>

                            </select>

                        </div>


                        <div class="datos-box">

                            <h3 style="margin-top:0;">

                                🚗 Información del vehículo

                            </h3>


                            <div class="datos-grid">


                                <div class="dato">

                                    <strong>
                                        Placa
                                    </strong>

                                    <span id="vehiculoPlaca">
                                        -
                                    </span>

                                </div>


                                <div class="dato">

                                    <strong>
                                        Marca
                                    </strong>

                                    <span id="vehiculoMarca">
                                        -
                                    </span>

                                </div>


                                <div class="dato">

                                    <strong>
                                        Modelo
                                    </strong>

                                    <span id="vehiculoModelo">
                                        -
                                    </span>

                                </div>


                                <div class="dato">

                                    <strong>
                                        Año
                                    </strong>

                                    <span id="vehiculoAnio">
                                        -
                                    </span>

                                </div>


                                <div class="dato">

                                    <strong>
                                        Color
                                    </strong>

                                    <span id="vehiculoColor">
                                        -
                                    </span>

                                </div>


                                <div class="dato">

                                    <strong>
                                        Tipo
                                    </strong>

                                    <span id="vehiculoTipo">
                                        -
                                    </span>

                                </div>


                            </div>

                        </div>

                    </div>

                </div>


                <!-- PRODUCTOS -->

                <div class="card">

                    <h2 class="titulo-card">

                        <span>🔧</span>

                        Producto / Servicio

                    </h2>


                    <div class="producto-selector">


                        <div class="campo">

                            <label for="productoSeleccionado">

                                📦 Producto del inventario

                            </label>


                            <select
                                id="productoSeleccionado"
                                onchange="cargarProducto()"
                            >

                                <option value="">

                                    Seleccione un producto

                                </option>


                                <%
                                    if (productos != null) {

                                        for (
                                            Producto producto :
                                            productos
                                        ) {

                                            boolean activo =
                                                    producto.getEstado() == null
                                                    || !"INACTIVO"
                                                        .equalsIgnoreCase(
                                                            producto.getEstado()
                                                        );

                                            if (activo) {
                                %>


                                <option
                                    value="<%= producto.getIdProducto() %>"

                                    data-id="<%= producto.getIdProducto() %>"

                                    data-codigo="<%= escaparHTML(
                                            producto.getCodigo()
                                    ) %>"

                                    data-nombre="<%= escaparHTML(
                                            producto.getNombre()
                                    ) %>"

                                    data-descripcion="<%= escaparHTML(
                                            producto.getDescripcion()
                                    ) %>"

                                    data-precio="<%= producto.getPrecioVenta() %>"

                                    data-stock="<%= producto.getCantidad() %>"
                                >

                                    <%= escaparHTML(
                                            producto.getCodigo()
                                    ) %>

                                    -

                                    <%= escaparHTML(
                                            producto.getNombre()
                                    ) %>

                                    | Stock:
                                    <%= producto.getCantidad() %>

                                </option>


                                <%
                                            }
                                        }
                                    }
                                %>

                            </select>

                        </div>


                        <div class="producto-info">


                            <div class="campo">

                                <label>
                                    Código
                                </label>

                                <input
                                    type="text"
                                    id="codigoProducto"
                                    readonly
                                >

                            </div>


                            <div class="campo">

                                <label>
                                    Nombre
                                </label>

                                <input
                                    type="text"
                                    id="nombreProducto"
                                    readonly
                                >

                            </div>


                            <div class="campo">

                                <label>
                                    Descripción
                                </label>

                                <input
                                    type="text"
                                    id="descripcionProducto"
                                >

                            </div>


                            <div class="campo">

                                <label>
                                    Precio unitario
                                </label>

                                <input
                                    type="number"
                                    id="precioProducto"
                                    min="0"
                                    step="0.01"
                                >

                            </div>


                            <div class="campo">

                                <label>
                                    Cantidad
                                </label>

                                <input
                                    type="number"
                                    id="cantidadProducto"
                                    min="1"
                                    value="1"
                                >

                            </div>


                            <div class="campo">

                                <label>
                                    Descuento
                                </label>

                                <input
                                    type="number"
                                    id="descuentoProducto"
                                    min="0"
                                    step="0.01"
                                    value="0"
                                >

                            </div>


                        </div>


                        <div style="margin-top:18px;">

                            <button
                                type="button"
                                class="boton boton-azul"
                                onclick="agregarProducto()"
                            >

                                ➕ Agregar producto

                            </button>

                        </div>

                    </div>


                    <!-- SERVICIO -->

                    <div class="servicio-box">

                        <p>

                            🔧 Puede agregar un servicio
                            manualmente.

                        </p>


                        <div class="producto-info">


                            <div class="campo">

                                <label>
                                    Descripción del servicio
                                </label>

                                <input
                                    type="text"
                                    id="descripcionServicio"
                                    placeholder="Ej. Diagnóstico eléctrico"
                                >

                            </div>


                            <div class="campo">

                                <label>
                                    Precio del servicio
                                </label>

                                <input
                                    type="number"
                                    id="precioServicio"
                                    min="0"
                                    step="0.01"
                                >

                            </div>


                            <div class="campo">

                                <label>
                                    Cantidad
                                </label>

                                <input
                                    type="number"
                                    id="cantidadServicio"
                                    min="1"
                                    value="1"
                                >

                            </div>


                            <div class="campo">

                                <label>
                                    Descuento
                                </label>

                                <input
                                    type="number"
                                    id="descuentoServicio"
                                    min="0"
                                    step="0.01"
                                    value="0"
                                >

                            </div>


                        </div>


                        <div style="margin-top:15px;">

                            <button
                                type="button"
                                class="boton boton-verde"
                                onclick="agregarServicio()"
                            >

                                🔧 Agregar servicio

                            </button>

                        </div>

                    </div>

                </div>


                <!-- DETALLE -->

                <div class="card">

                    <h2 class="titulo-card">

                        <span>📋</span>

                        Detalle de la factura

                    </h2>


                    <div class="tabla-contenedor">

                        <table>

                            <thead>

                                <tr>

                                    <th>
                                        Tipo
                                    </th>

                                    <th>
                                        Código
                                    </th>

                                    <th>
                                        Descripción
                                    </th>

                                    <th>
                                        Cantidad
                                    </th>

                                    <th>
                                        Precio unitario
                                    </th>

                                    <th>
                                        Descuento
                                    </th>

                                    <th>
                                        Subtotal
                                    </th>

                                    <th>
                                        Acción
                                    </th>

                                </tr>

                            </thead>


                            <tbody id="tablaDetalles">

                                <tr>

                                    <td
                                        colspan="8"
                                        class="sin-datos"
                                    >

                                        📦 No hay productos
                                        o servicios agregados.

                                    </td>

                                </tr>

                            </tbody>

                        </table>

                    </div>

                </div>


                <div id="camposOcultos"></div>


            </div>


            <!-- RESUMEN -->

            <aside>

                <div class="card resumen">

                    <h2 class="titulo-card">

                        <span>💰</span>

                        Resumen

                    </h2>


                    <div class="resumen-linea">

                        <span>
                            Subtotal
                        </span>

                        <strong
                            id="mostrarSubtotal"
                        >
                            $0
                        </strong>

                    </div>


                    <div class="resumen-linea">

                        <span>
                            Descuento
                        </span>

                        <strong
                            id="mostrarDescuento"
                        >
                            $0
                        </strong>

                    </div>


                    <div class="resumen-linea">

                        <span>
                            Impuesto
                        </span>

                        <strong
                            id="mostrarImpuesto"
                        >
                            $0
                        </strong>

                    </div>


                    <div class="total-final">

                        <span>
                            Total
                        </span>

                        <strong
                            id="mostrarTotal"
                        >
                            $0
                        </strong>

                    </div>


                    <input
                        type="hidden"
                        name="subtotal"
                        id="subtotal"
                        value="0"
                    >


                    <input
                        type="hidden"
                        name="descuento"
                        id="descuento"
                        value="0"
                    >


                    <input
                        type="hidden"
                        name="impuesto"
                        id="impuesto"
                        value="0"
                    >


                    <input
                        type="hidden"
                        name="total"
                        id="total"
                        value="0"
                    >


                    <div class="acciones-finales">


                        <button
                            type="submit"
                            class="boton boton-verde"
                        >

                            💾 Guardar factura

                        </button>


                        <button
                            type="button"
                            class="boton boton-negro"
                            onclick="imprimirFactura()"
                        >

                            🖨️ Imprimir factura

                        </button>


                        <button
                            type="button"
                            class="boton boton-whatsapp"
                            onclick="enviarWhatsApp()"
                        >

                            💬 WhatsApp

                        </button>


                        <button
                            type="button"
                            class="boton boton-gris"
                            onclick="limpiarFactura()"
                        >

                            🧹 Limpiar

                        </button>


                    </div>

                </div>

            </aside>


        </div>


    </form>


</div>


<!-- ==========================================================
     FACTURA PARA IMPRESIÓN
     ========================================================== -->

<div id="facturaImpresion">

    <div class="factura-print-header">

        <div class="taller-identidad-print">
            <div class="logo-taller-print">🚗</div>
            <div>
                <h1>ELECTRICISTA LONDOÑO</h1>
                <p><strong>SIGTAL</strong> - Sistema Integral de Gestión para Taller Automotriz</p>
                <p>Barranquilla, Atlántico, Colombia</p>
            </div>
        </div>

        <div class="factura-caja-print">
            <h2>FACTURA DE VENTA</h2>
            <div class="numero-print">N.º <span id="impNumeroFactura">
                <% if (facturaSeleccionada != null) { %>
                    <%= escaparHTML(String.valueOf(facturaSeleccionada.get("numeroFactura"))) %>
                <% } else { %>
                    <%= escaparHTML(numeroFactura) %>
                <% } %>
            </span></div>
            <div class="estado-print"><strong>Estado:</strong> <span id="impEstado">
                <% if (facturaSeleccionada != null) { %>
                    <%= escaparHTML(String.valueOf(facturaSeleccionada.get("estado"))) %>
                <% } else { %>
                    PENDIENTE
                <% } %>
            </span></div>
            <div class="fecha-print"><strong>Fecha:</strong> <span id="impFecha">
                <% if (facturaSeleccionada != null) { %>
                    <%= escaparHTML(String.valueOf(facturaSeleccionada.get("fechaFactura"))) %>
                <% } else { %>
                    <%= formatoFecha.format(new java.util.Date()) %>
                <% } %>
            </span></div>
        </div>

    </div>

    <div class="datos-doble-print">

        <div class="bloque-print">
            <div class="titulo-bloque-print">DATOS DEL CLIENTE</div>

            <div class="fila-print"><strong>Nombre:</strong><span id="impCliente">
                <% if (facturaSeleccionada != null) { %><%= escaparHTML(String.valueOf(facturaSeleccionada.get("nombreCliente"))) %><% } else { %>-<% } %>
            </span></div>

            <div class="fila-print"><strong>Documento:</strong><span id="impDocumento">
                <% if (facturaSeleccionada != null) { %><%= escaparHTML(String.valueOf(facturaSeleccionada.get("documentoCliente"))) %><% } else { %>-<% } %>
            </span></div>

            <div class="fila-print"><strong>Teléfono:</strong><span id="impTelefono">
                <% if (facturaSeleccionada != null) { %><%= escaparHTML(String.valueOf(facturaSeleccionada.get("telefonoCliente"))) %><% } else { %>-<% } %>
            </span></div>

            <div class="fila-print"><strong>Correo:</strong><span id="impCorreo">
                <% if (facturaSeleccionada != null) { %><%= escaparHTML(String.valueOf(facturaSeleccionada.get("correoCliente"))) %><% } else { %>-<% } %>
            </span></div>

            <div class="fila-print"><strong>Dirección:</strong><span id="impDireccion">
                <% if (facturaSeleccionada != null) { %><%= escaparHTML(String.valueOf(facturaSeleccionada.get("direccionCliente"))) %><% } else { %>-<% } %>
            </span></div>
        </div>

        <div class="bloque-print">
            <div class="titulo-bloque-print">DATOS DEL VEHÍCULO</div>

            <div class="fila-print"><strong>Placa:</strong><span id="impVehiculoPlaca">
                <% if (facturaSeleccionada != null) { %><%= escaparHTML(String.valueOf(facturaSeleccionada.get("placaVehiculo"))) %><% } else { %>-<% } %>
            </span></div>

            <div class="fila-print"><strong>Marca:</strong><span id="impVehiculoMarca">
                <% if (facturaSeleccionada != null) { %><%= escaparHTML(String.valueOf(facturaSeleccionada.get("marcaVehiculo"))) %><% } else { %>-<% } %>
            </span></div>

            <div class="fila-print"><strong>Modelo:</strong><span id="impVehiculoModelo">
                <% if (facturaSeleccionada != null) { %><%= escaparHTML(String.valueOf(facturaSeleccionada.get("modeloVehiculo"))) %><% } else { %>-<% } %>
            </span></div>

            <div class="fila-print"><strong>Año:</strong><span id="impVehiculoAnio">-</span></div>
            <div class="fila-print"><strong>Color:</strong><span id="impVehiculoColor">-</span></div>
            <div class="fila-print"><strong>Tipo:</strong><span id="impVehiculoTipo">-</span></div>
        </div>

    </div>

    <div class="detalle-print">
        <div class="titulo-detalle-print">DETALLE DE LA FACTURA</div>

        <table id="tablaImpresion">
            <thead>
                <tr>
                    <th>Tipo</th>
                    <th>Código</th>
                    <th>Descripción</th>
                    <th>Cantidad</th>
                    <th>Precio unitario</th>
                    <th>Descuento</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody id="tablaImpresionBody">
                <% if (facturaSeleccionada != null && detallesSeleccionados != null && !detallesSeleccionados.isEmpty()) { %>
                    <% for (Map<String,Object> detalle : detallesSeleccionados) { %>
                        <tr>
                            <td><%= detalle.get("idProducto") == null ? "Servicio" : "Producto" %></td>
                            <td><%= escaparHTML(detalle.get("codigo") == null ? "-" : detalle.get("codigo").toString()) %></td>
                            <td><%= escaparHTML(detalle.get("descripcion") == null ? "-" : detalle.get("descripcion").toString()) %></td>
                            <td><%= detalle.get("cantidad") == null ? "0" : detalle.get("cantidad") %></td>
                            <td><%= moneda(detalle.get("precioUnitario")) %></td>
                            <td><%= moneda(detalle.get("descuento")) %></td>
                            <td><strong><%= moneda(detalle.get("subtotal")) %></strong></td>
                        </tr>
                    <% } %>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="zona-totales-print">
        <div class="observaciones-print">
            <strong>Observaciones</strong>
            <p>Gracias por confiar en <strong>Electricista Londoño</strong>.</p>
            <p>Servicio • Confianza • Soluciones</p>
        </div>

        <div class="print-resumen">
            <div><span>Subtotal:</span><strong id="impSubtotal"><% if (facturaSeleccionada != null) { %><%= moneda(facturaSeleccionada.get("subtotal")) %><% } else { %>$0<% } %></strong></div>
            <div><span>Descuento:</span><strong id="impDescuento"><% if (facturaSeleccionada != null) { %><%= moneda(facturaSeleccionada.get("descuento")) %><% } else { %>$0<% } %></strong></div>
            <div><span>Impuesto:</span><strong id="impImpuesto"><% if (facturaSeleccionada != null) { %><%= moneda(facturaSeleccionada.get("impuesto")) %><% } else { %>$0<% } %></strong></div>
            <div class="print-total"><span>TOTAL:</span><strong id="impTotal"><% if (facturaSeleccionada != null) { %><%= moneda(facturaSeleccionada.get("total")) %><% } else { %>$0<% } %></strong></div>
        </div>
    </div>

    <div class="footer-factura-print">
        <strong>ELECTRICISTA LONDOÑO</strong>
        <span>SIGTAL - Sistema Integral de Gestión para Taller Automotriz</span>
        <span>Barranquilla, Atlántico, Colombia</span>
        <em>¡Gracias por su confianza!</em>
    </div>

</div>

<script>


/* ==========================================================
   VARIABLES
   ========================================================== */

let detalles = [];


/* ==========================================================
   FORMATO MONEDA
   ========================================================== */

function formatoMoneda(valor) {

    valor =
        Number(valor) || 0;


    return new Intl.NumberFormat(
        "es-CO",
        {
            style: "currency",
            currency: "COP",
            maximumFractionDigits: 0
        }
    ).format(valor);
}


/* ==========================================================
   MOSTRAR BUSCADOR
   ========================================================== */

function mostrarBuscador() {

    const buscador =
        document.getElementById(
            "seccionBuscador"
        );


    if (!buscador) {
        return;
    }


    if (buscador.style.display === "none"
            || buscador.style.display === "") {

        buscador.style.display =
            "block";

        buscador.scrollIntoView({
            behavior: "smooth",
            block: "start"
        });

    } else {

        buscador.style.display =
            "none";
    }
}


/* ==========================================================
   CLIENTE
   ========================================================== */

function cargarCliente() {

    const select =
        document.getElementById(
            "idCliente"
        );


    if (!select) {
        return;
    }


    const opcion =
        select.options[
            select.selectedIndex
        ];


    if (!opcion
            || !opcion.value) {

        document.getElementById(
            "clienteNombre"
        ).textContent = "-";

        document.getElementById(
            "clienteDocumento"
        ).textContent = "-";

        document.getElementById(
            "clienteTelefono"
        ).textContent = "-";

        document.getElementById(
            "clienteCorreo"
        ).textContent = "-";

        document.getElementById(
            "clienteDireccion"
        ).textContent = "-";


        document.getElementById(
            "idVehiculo"
        ).innerHTML =
            '<option value="0">Seleccione un vehículo</option>';


        limpiarVehiculo();

        return;
    }


    document.getElementById(
        "clienteNombre"
    ).textContent =
        opcion.dataset.nombre || "-";


    document.getElementById(
        "clienteDocumento"
    ).textContent =
        opcion.dataset.documento || "-";


    document.getElementById(
        "clienteTelefono"
    ).textContent =
        opcion.dataset.telefono || "-";


    document.getElementById(
        "clienteCorreo"
    ).textContent =
        opcion.dataset.correo || "-";


    document.getElementById(
        "clienteDireccion"
    ).textContent =
        opcion.dataset.direccion || "-";


    const idCliente =
        opcion.value;


    const url =
        "<%= request.getContextPath() %>"
        + "/facturacion?idCliente="
        + encodeURIComponent(
            idCliente
        );


    window.location.href =
        url;
}


/* ==========================================================
   VEHÍCULO
   ========================================================== */

function actualizarVehiculo() {

    const select =
        document.getElementById(
            "idVehiculo"
        );


    if (!select) {
        return;
    }


    const opcion =
        select.options[
            select.selectedIndex
        ];


    if (!opcion
            || !opcion.value
            || opcion.value === "0") {

        limpiarVehiculo();

        return;
    }


    document.getElementById(
        "vehiculoPlaca"
    ).textContent =
        opcion.dataset.placa || "-";


    document.getElementById(
        "vehiculoMarca"
    ).textContent =
        opcion.dataset.marca || "-";


    document.getElementById(
        "vehiculoModelo"
    ).textContent =
        opcion.dataset.modelo || "-";


    document.getElementById(
        "vehiculoAnio"
    ).textContent =
        opcion.dataset.anio || "-";


    document.getElementById(
        "vehiculoColor"
    ).textContent =
        opcion.dataset.color || "-";


    document.getElementById(
        "vehiculoTipo"
    ).textContent =
        opcion.dataset.tipo || "-";


    actualizarVehiculoImpresion(
        opcion
    );
}


/* ==========================================================
   LIMPIAR VEHÍCULO
   ========================================================== */

function limpiarVehiculo() {

    document.getElementById(
        "vehiculoPlaca"
    ).textContent = "-";

    document.getElementById(
        "vehiculoMarca"
    ).textContent = "-";

    document.getElementById(
        "vehiculoModelo"
    ).textContent = "-";

    document.getElementById(
        "vehiculoAnio"
    ).textContent = "-";

    document.getElementById(
        "vehiculoColor"
    ).textContent = "-";

    document.getElementById(
        "vehiculoTipo"
    ).textContent = "-";


    document.getElementById(
        "impVehiculoPlaca"
    ).textContent = "-";

    document.getElementById(
        "impVehiculoMarca"
    ).textContent = "-";

    document.getElementById(
        "impVehiculoModelo"
    ).textContent = "-";

    document.getElementById(
        "impVehiculoAnio"
    ).textContent = "-";

    document.getElementById(
        "impVehiculoColor"
    ).textContent = "-";

    document.getElementById(
        "impVehiculoTipo"
    ).textContent = "-";
}


/* ==========================================================
   VEHÍCULO IMPRESIÓN
   ========================================================== */

function actualizarVehiculoImpresion(
    opcion
) {

    document.getElementById(
        "impVehiculoPlaca"
    ).textContent =
        opcion.dataset.placa || "-";


    document.getElementById(
        "impVehiculoMarca"
    ).textContent =
        opcion.dataset.marca || "-";


    document.getElementById(
        "impVehiculoModelo"
    ).textContent =
        opcion.dataset.modelo || "-";


    document.getElementById(
        "impVehiculoAnio"
    ).textContent =
        opcion.dataset.anio || "-";


    document.getElementById(
        "impVehiculoColor"
    ).textContent =
        opcion.dataset.color || "-";


    document.getElementById(
        "impVehiculoTipo"
    ).textContent =
        opcion.dataset.tipo || "-";
}


/* ==========================================================
   PRODUCTO
   ========================================================== */

function cargarProducto() {

    const select =
        document.getElementById(
            "productoSeleccionado"
        );


    const opcion =
        select.options[
            select.selectedIndex
        ];


    if (!opcion
            || !opcion.value) {

        limpiarProducto();

        return;
    }


    const precio =
        Number(
            opcion.dataset.precio
        ) || 0;


    document.getElementById(
        "codigoProducto"
    ).value =
        opcion.dataset.codigo || "";


    document.getElementById(
        "nombreProducto"
    ).value =
        opcion.dataset.nombre || "";


    document.getElementById(
        "descripcionProducto"
    ).value =
        opcion.dataset.descripcion
        || opcion.dataset.nombre
        || "";


    document.getElementById(
        "precioProducto"
    ).value =
        precio;


    document.getElementById(
        "cantidadProducto"
    ).value = 1;


    document.getElementById(
        "descuentoProducto"
    ).value = 0;
}


/* ==========================================================
   LIMPIAR PRODUCTO
   ========================================================== */

function limpiarProducto() {

    document.getElementById(
        "productoSeleccionado"
    ).value = "";


    document.getElementById(
        "codigoProducto"
    ).value = "";


    document.getElementById(
        "nombreProducto"
    ).value = "";


    document.getElementById(
        "descripcionProducto"
    ).value = "";


    document.getElementById(
        "precioProducto"
    ).value = "";


    document.getElementById(
        "cantidadProducto"
    ).value = 1;


    document.getElementById(
        "descuentoProducto"
    ).value = 0;
}


/* ==========================================================
   AGREGAR PRODUCTO
   ========================================================== */

function agregarProducto() {

    const select =
        document.getElementById(
            "productoSeleccionado"
        );


    const opcion =
        select.options[
            select.selectedIndex
        ];


    if (!opcion
            || !opcion.value) {

        alert(
            "Seleccione un producto del inventario."
        );

        return;
    }


    const descripcion =
        document.getElementById(
            "descripcionProducto"
        ).value.trim();


    const cantidad =
        parseInt(
            document.getElementById(
                "cantidadProducto"
            ).value
        ) || 1;


    const precio =
        parseFloat(
            document.getElementById(
                "precioProducto"
            ).value
        ) || 0;


    const descuento =
        parseFloat(
            document.getElementById(
                "descuentoProducto"
            ).value
        ) || 0;


    if (!descripcion) {

        alert(
            "Ingrese la descripción del producto."
        );

        return;
    }


    if (cantidad <= 0) {

        alert(
            "La cantidad debe ser mayor que cero."
        );

        return;
    }


    if (precio < 0) {

        alert(
            "El precio no puede ser negativo."
        );

        return;
    }


    if (descuento < 0) {

        alert(
            "El descuento no puede ser negativo."
        );

        return;
    }


    const stock =
        parseInt(
            opcion.dataset.stock
        ) || 0;


    if (cantidad > stock) {

        alert(
            "La cantidad solicitada supera el stock disponible."
            + "\nStock disponible: "
            + stock
        );

        return;
    }


    const subtotal =
        Math.max(
            0,
            (precio * cantidad)
            - descuento
        );


    detalles.push({

        tipo: "Producto",

        idProducto:
            opcion.value,

        codigo:
            opcion.dataset.codigo || "",

        descripcion:
            descripcion,

        cantidad:
            cantidad,

        precioUnitario:
            precio,

        descuento:
            descuento,

        subtotal:
            subtotal
    });


    renderizarDetalles();

    limpiarProducto();
}


/* ==========================================================
   AGREGAR SERVICIO
   ========================================================== */

function agregarServicio() {

    const descripcion =
        document.getElementById(
            "descripcionServicio"
        ).value.trim();


    const precio =
        parseFloat(
            document.getElementById(
                "precioServicio"
            ).value
        ) || 0;


    const cantidad =
        parseInt(
            document.getElementById(
                "cantidadServicio"
            ).value
        ) || 1;


    const descuento =
        parseFloat(
            document.getElementById(
                "descuentoServicio"
            ).value
        ) || 0;


    if (!descripcion) {

        alert(
            "Ingrese la descripción del servicio."
        );

        return;
    }


    if (precio < 0) {

        alert(
            "El precio no puede ser negativo."
        );

        return;
    }


    if (cantidad <= 0) {

        alert(
            "La cantidad debe ser mayor que cero."
        );

        return;
    }


    const subtotal =
        Math.max(
            0,
            (precio * cantidad)
            - descuento
        );


    detalles.push({

        tipo: "Servicio",

        idProducto: "",

        codigo: "-",

        descripcion:
            descripcion,

        cantidad:
            cantidad,

        precioUnitario:
            precio,

        descuento:
            descuento,

        subtotal:
            subtotal
    });


    renderizarDetalles();


    document.getElementById(
        "descripcionServicio"
    ).value = "";


    document.getElementById(
        "precioServicio"
    ).value = "";


    document.getElementById(
        "cantidadServicio"
    ).value = 1;


    document.getElementById(
        "descuentoServicio"
    ).value = 0;
}


/* ==========================================================
   RENDERIZAR DETALLES
   ========================================================== */

function renderizarDetalles() {

    const tbody =
        document.getElementById(
            "tablaDetalles"
        );


    tbody.innerHTML = "";


    if (detalles.length === 0) {

        const fila =
            document.createElement(
                "tr"
            );


        const celda =
            document.createElement(
                "td"
            );


        celda.colSpan = 8;

        celda.className =
            "sin-datos";


        celda.textContent =
            "📦 No hay productos o servicios agregados.";


        fila.appendChild(celda);

        tbody.appendChild(fila);


        actualizarTotales();

        return;
    }


    detalles.forEach(
        function(detalle, indice) {

            const fila =
                document.createElement(
                    "tr"
                );


            const tdTipo =
                document.createElement(
                    "td"
                );


            const badge =
                document.createElement(
                    "span"
                );


            badge.className =
                "badge";


            badge.textContent =
                detalle.tipo || "-";


            tdTipo.appendChild(
                badge
            );


            const tdCodigo =
                document.createElement(
                    "td"
                );


            tdCodigo.textContent =
                detalle.codigo || "-";


            const tdDescripcion =
                document.createElement(
                    "td"
                );


            tdDescripcion.textContent =
                detalle.descripcion || "-";


            const tdCantidad =
                document.createElement(
                    "td"
                );


            tdCantidad.textContent =
                detalle.cantidad;


            const tdPrecio =
                document.createElement(
                    "td"
                );


            tdPrecio.textContent =
                formatoMoneda(
                    detalle.precioUnitario
                );


            const tdDescuento =
                document.createElement(
                    "td"
                );


            tdDescuento.textContent =
                formatoMoneda(
                    detalle.descuento
                );


            const tdSubtotal =
                document.createElement(
                    "td"
                );


            const strong =
                document.createElement(
                    "strong"
                );


            strong.textContent =
                formatoMoneda(
                    detalle.subtotal
                );


            tdSubtotal.appendChild(
                strong
            );


            const tdAccion =
                document.createElement(
                    "td"
                );


            const boton =
                document.createElement(
                    "button"
                );


            boton.type =
                "button";


            boton.className =
                "boton-eliminar";


            boton.textContent =
                "✕";


            boton.title =
                "Eliminar";


            boton.addEventListener(
                "click",
                function() {

                    eliminarDetalle(
                        indice
                    );

                }
            );


            tdAccion.appendChild(
                boton
            );


            fila.appendChild(tdTipo);
            fila.appendChild(tdCodigo);
            fila.appendChild(tdDescripcion);
            fila.appendChild(tdCantidad);
            fila.appendChild(tdPrecio);
            fila.appendChild(tdDescuento);
            fila.appendChild(tdSubtotal);
            fila.appendChild(tdAccion);


            tbody.appendChild(fila);

        }
    );


    actualizarTotales();
}


/* ==========================================================
   ELIMINAR DETALLE
   ========================================================== */

function eliminarDetalle(indice) {

    if (
        indice < 0
        || indice >= detalles.length
    ) {

        return;
    }


    detalles.splice(
        indice,
        1
    );


    renderizarDetalles();
}


/* ==========================================================
   TOTALES
   ========================================================== */

function actualizarTotales() {

    let subtotalBruto = 0;

    let descuentoTotal = 0;


    detalles.forEach(
        function(detalle) {

            subtotalBruto +=
                detalle.precioUnitario
                * detalle.cantidad;


            descuentoTotal +=
                detalle.descuento;
        }
    );


    const subtotal =
        Math.max(
            0,
            subtotalBruto
            - descuentoTotal
        );


    const impuesto = 0;


    const total =
        subtotal + impuesto;


    document.getElementById(
        "mostrarSubtotal"
    ).textContent =
        formatoMoneda(
            subtotal
        );


    document.getElementById(
        "mostrarDescuento"
    ).textContent =
        formatoMoneda(
            descuentoTotal
        );


    document.getElementById(
        "mostrarImpuesto"
    ).textContent =
        formatoMoneda(
            impuesto
        );


    document.getElementById(
        "mostrarTotal"
    ).textContent =
        formatoMoneda(
            total
        );


    document.getElementById(
        "subtotal"
    ).value =
        subtotal.toFixed(2);


    document.getElementById(
        "descuento"
    ).value =
        descuentoTotal.toFixed(2);


    document.getElementById(
        "impuesto"
    ).value =
        impuesto.toFixed(2);


    document.getElementById(
        "total"
    ).value =
        total.toFixed(2);
}


/* ==========================================================
   PREPARAR FACTURA
   ========================================================== */

function prepararFactura() {

    const idCliente =
        document.getElementById(
            "idCliente"
        ).value;


    if (!idCliente) {

        alert(
            "Seleccione un cliente."
        );

        return false;
    }


    if (detalles.length === 0) {

        alert(
            "Debe agregar al menos un producto o servicio."
        );

        return false;
    }


    actualizarTotales();


    const campos =
        document.getElementById(
            "camposOcultos"
        );


    campos.innerHTML = "";


    detalles.forEach(
        function(detalle) {

            agregarCampoOculto(
                campos,
                "idProducto",
                detalle.idProducto
            );


            agregarCampoOculto(
                campos,
                "descripcion",
                detalle.descripcion
            );


            agregarCampoOculto(
                campos,
                "cantidad",
                detalle.cantidad
            );


            agregarCampoOculto(
                campos,
                "precioUnitario",
                detalle.precioUnitario
            );


            agregarCampoOculto(
                campos,
                "descuentoDetalle",
                detalle.descuento
            );

        }
    );


    return true;
}


/* ==========================================================
   CAMPO OCULTO
   ========================================================== */

function agregarCampoOculto(
    contenedor,
    nombre,
    valor
) {

    const input =
        document.createElement(
            "input"
        );


    input.type =
        "hidden";


    input.name =
        nombre;


    input.value =
        valor == null
        ? ""
        : valor;


    contenedor.appendChild(
        input
    );
}


/* ==========================================================
   IMPRESIÓN
   ========================================================== */

function prepararFacturaImpresion() {

    const clienteSelect = document.getElementById("idCliente");
    const clienteOpcion = clienteSelect && clienteSelect.selectedIndex >= 0
        ? clienteSelect.options[clienteSelect.selectedIndex]
        : null;

    const poner = function(id, valor) {
        const elemento = document.getElementById(id);
        if (elemento) elemento.textContent = valor || "-";
    };

    poner("impCliente", clienteOpcion?.dataset?.nombre);
    poner("impDocumento", clienteOpcion?.dataset?.documento);
    poner("impTelefono", clienteOpcion?.dataset?.telefono);
    poner("impCorreo", clienteOpcion?.dataset?.correo);
    poner("impDireccion", clienteOpcion?.dataset?.direccion);

    const numero = document.getElementById("numeroFactura");
    poner("impNumeroFactura", numero ? numero.value : "Se generará al guardar");

    const estadoSelect = document.getElementById("estado");
    if (estadoSelect && estadoSelect.selectedIndex >= 0) {
        poner("impEstado", estadoSelect.options[estadoSelect.selectedIndex].text);
    }

    const fecha = document.getElementById("impFecha");
    if (fecha) {
        const ahora = new Date();
        fecha.textContent = ahora.toLocaleString("es-CO");
    }

    const vehiculoSelect = document.getElementById("idVehiculo");
    const vehiculoOpcion = vehiculoSelect && vehiculoSelect.selectedIndex >= 0
        ? vehiculoSelect.options[vehiculoSelect.selectedIndex]
        : null;

    poner("impVehiculoPlaca", vehiculoOpcion?.dataset?.placa);
    poner("impVehiculoMarca", vehiculoOpcion?.dataset?.marca);
    poner("impVehiculoModelo", vehiculoOpcion?.dataset?.modelo);
    poner("impVehiculoAnio", vehiculoOpcion?.dataset?.anio);
    poner("impVehiculoColor", vehiculoOpcion?.dataset?.color);
    poner("impVehiculoTipo", vehiculoOpcion?.dataset?.tipo);

    const tbody = document.getElementById("tablaImpresionBody");
    if (!tbody) return;

    tbody.innerHTML = "";

    detalles.forEach(function(detalle) {
        const fila = document.createElement("tr");

        [
            detalle.tipo || "-",
            detalle.codigo || "-",
            detalle.descripcion || "-",
            detalle.cantidad ?? 0,
            formatoMoneda(detalle.precioUnitario),
            formatoMoneda(detalle.descuento),
            formatoMoneda(detalle.subtotal)
        ].forEach(function(valor, indice) {
            const td = document.createElement("td");
            td.textContent = valor;
            if (indice === 6) {
                const strong = document.createElement("strong");
                strong.textContent = valor;
                td.textContent = "";
                td.appendChild(strong);
            }
            fila.appendChild(td);
        });

        tbody.appendChild(fila);
    });

    const mostrar = function(origen, destino) {
        const a = document.getElementById(origen);
        const b = document.getElementById(destino);
        if (a && b) b.textContent = a.textContent;
    };

    mostrar("mostrarSubtotal", "impSubtotal");
    mostrar("mostrarDescuento", "impDescuento");
    mostrar("mostrarImpuesto", "impImpuesto");
    mostrar("mostrarTotal", "impTotal");
}


/* ==========================================================
   IMPRIMIR
   ========================================================== */

function imprimirFactura() {

    if (detalles.length === 0) {

        alert(
            "Agregue al menos un producto o servicio antes de imprimir."
        );

        return;
    }


    prepararFacturaImpresion();


    window.print();
}


/* ==========================================================
   WHATSAPP
   ========================================================== */

function enviarWhatsApp() {

    if (detalles.length === 0) {

        alert(
            "Agregue al menos un producto o servicio."
        );

        return;
    }


    const clienteSelect =
        document.getElementById(
            "idCliente"
        );


    const opcion =
        clienteSelect.options[
            clienteSelect.selectedIndex
        ];


    if (!opcion
            || !opcion.value) {

        alert(
            "Seleccione un cliente."
        );

        return;
    }


    const nombre =
        opcion.dataset.nombre
        || "Cliente";


    const telefono =
        opcion.dataset.telefono
        || "";


    if (!telefono) {

        alert(
            "El cliente no tiene un número de teléfono registrado."
        );

        return;
    }


    let mensaje =
        "Hola "
        + nombre
        + ",\n\n";


    mensaje +=
        "Le compartimos el detalle de su factura de "
        + "Electricista Londoño.\n\n";


    detalles.forEach(
        function(detalle) {

            mensaje +=
                "• "
                + detalle.descripcion
                + " x"
                + detalle.cantidad
                + " = "
                + formatoMoneda(
                    detalle.subtotal
                )
                + "\n";
        }
    );


    mensaje +=
        "\nTotal: "
        + document.getElementById(
            "mostrarTotal"
        ).textContent
        + "\n\n";


    mensaje +=
        "Gracias por confiar en Electricista Londoño.";


    let numero =
        telefono.replace(
            /\D/g,
            ""
        );


    if (numero.length === 10) {

        numero =
            "57"
            + numero;
    }


    const url =
        "https://wa.me/"
        + numero
        + "?text="
        + encodeURIComponent(
            mensaje
        );


    window.open(
        url,
        "_blank"
    );
}


/* ==========================================================
   LIMPIAR
   ========================================================== */

function limpiarFactura() {

    const confirmar =
        confirm(
            "¿Desea limpiar toda la factura?"
        );


    if (!confirmar) {
        return;
    }


    detalles = [];


    document.getElementById(
        "idCliente"
    ).value = "";


    document.getElementById(
        "idVehiculo"
    ).innerHTML =
        '<option value="0">Seleccione un vehículo</option>';


    document.getElementById(
        "clienteNombre"
    ).textContent = "-";


    document.getElementById(
        "clienteDocumento"
    ).textContent = "-";


    document.getElementById(
        "clienteTelefono"
    ).textContent = "-";


    document.getElementById(
        "clienteCorreo"
    ).textContent = "-";


    document.getElementById(
        "clienteDireccion"
    ).textContent = "-";


    limpiarVehiculo();

    limpiarProducto();


    document.getElementById(
        "descripcionServicio"
    ).value = "";


    document.getElementById(
        "precioServicio"
    ).value = "";


    document.getElementById(
        "cantidadServicio"
    ).value = 1;


    document.getElementById(
        "descuentoServicio"
    ).value = 0;


    document.getElementById(
        "estado"
    ).value =
        "PENDIENTE";


    renderizarDetalles();
}


/* ==========================================================
   CONFIRMAR ELIMINACIÓN
   ========================================================== */

function confirmarEliminarFactura() {

    return confirm(
        "¿Está seguro de eliminar esta factura?\n\n"
        + "También se eliminarán sus detalles."
    );
}


/* ==========================================================
   ACCIONES DE FACTURAS GUARDADAS
   ========================================================== */

function imprimirFacturaGuardada(idFactura) {

    if (!idFactura) {
        alert("No se encontró el ID de la factura.");
        return;
    }

    const url =
        "<%= request.getContextPath() %>"
        + "/facturacion?accion=imprimirFactura&idFactura="
        + encodeURIComponent(idFactura);

    window.location.href = url;
}


async function enviarFacturaGuardada(boton) {

    if (!boton) {
        alert("No se pudo obtener la información de la factura.");
        return;
    }

    const telefono = boton.dataset.telefono || "";
    const cliente = boton.dataset.cliente || "Cliente";
    const numeroFactura = boton.dataset.factura || "";
    const total = boton.dataset.total || "$0";
    const estado = boton.dataset.estado || "";

    if (!telefono.trim()) {
        alert("El cliente no tiene un número de teléfono registrado.");
        return;
    }

    let numero = telefono.replace(/\D/g, "");

    if (numero.length === 10) {
        numero = "57" + numero;
    }

    if (numero.length < 10) {
        alert("El número de teléfono del cliente no es válido.");
        return;
    }

    /*
     * Obtenemos la factura completa desde SIGTAL para incluir
     * también los productos/servicios, cantidades y valores.
     * La búsqueda actual solo tenía disponibles los datos
     * generales de la factura.
     */
    let fecha = "";
    let documento = "";
    let telefonoFactura = telefono;
    let correo = "";
    let direccion = "";
    let vehiculo = "";
    let detalles = [];
    let subtotal = "";
    let descuento = "";
    let impuesto = "";

    /* Abrimos una pestaña inmediatamente para evitar que el navegador
       bloquee WhatsApp cuando terminemos la consulta asíncrona. */
    const ventanaWhatsApp = window.open("about:blank", "_blank");

    try {

        /* Si el botón está en una fila, obtenemos el ID desde el
           formulario de eliminar de esa misma fila. */
        let idFactura =
            boton.closest("tr")
            ?.querySelector('input[name="idFactura"]')?.value || "";

        if (!idFactura) {
            throw new Error("No se encontró el ID de la factura.");
        }

        const respuesta = await fetch(
            "<%= request.getContextPath() %>/facturacion?accion=verFactura&idFactura="
            + encodeURIComponent(idFactura),
            {
                method: "GET",
                headers: {
                    "X-Requested-With": "XMLHttpRequest"
                }
            }
        );

        if (!respuesta.ok) {
            throw new Error("No se pudo consultar la factura.");
        }

        const html = await respuesta.text();
        const parser = new DOMParser();
        const documentoHTML = parser.parseFromString(html, "text/html");

        const datos = documentoHTML.querySelectorAll(
            "#facturaGuardada .factura-guardada-datos .dato"
        );

        datos.forEach(function(dato) {

            const etiqueta =
                dato.querySelector("strong")?.textContent
                .trim()
                .toLowerCase() || "";

            const valor =
                dato.querySelector("span")?.textContent
                .trim() || "";

            if (etiqueta === "fecha") fecha = valor;
            if (etiqueta === "documento") documento = valor;
            if (etiqueta === "teléfono") telefonoFactura = valor;
            if (etiqueta === "correo") correo = valor;
            if (etiqueta === "dirección") direccion = valor;
            if (etiqueta === "vehículo") vehiculo = valor;
        });

        const filas = documentoHTML.querySelectorAll(
            "#facturaGuardada .tabla-factura-guardada tbody tr"
        );

        filas.forEach(function(fila) {

            const celdas = fila.querySelectorAll("td");

            if (celdas.length >= 7) {
                detalles.push({
                    tipo: celdas[0].textContent.trim(),
                    codigo: celdas[1].textContent.trim(),
                    descripcion: celdas[2].textContent.trim(),
                    cantidad: celdas[3].textContent.trim(),
                    precio: celdas[4].textContent.trim(),
                    descuento: celdas[5].textContent.trim(),
                    subtotal: celdas[6].textContent.trim()
                });
            }
        });

        const resumen =
            documentoHTML.querySelectorAll(
                "#facturaGuardada .totales-guardada .resumen-linea"
            );

        resumen.forEach(function(linea) {

            const etiqueta =
                linea.querySelector("span")?.textContent
                .trim()
                .toLowerCase() || "";

            const valor =
                linea.querySelector("strong")?.textContent
                .trim() || "";

            if (etiqueta === "subtotal") subtotal = valor;
            if (etiqueta === "descuento") descuento = valor;
            if (etiqueta === "impuesto") impuesto = valor;
        });

    } catch (error) {

        console.error("Error al obtener el detalle de la factura:", error);

        /* Si por alguna razón no se puede consultar el detalle,
           todavía permitimos enviar la información básica. */
    }

    let mensaje = "Hola " + cliente + ",\n\n";

    mensaje += "🧾 *ELECTRICISTA LONDOÑO*\n";
    mensaje += "SIGTAL - Sistema Integral de Gestión para Taller Automotriz\n\n";

    mensaje += "*FACTURA DE VENTA*\n";
    mensaje += "Factura: " + numeroFactura + "\n";

    if (fecha) {
        mensaje += "Fecha: " + fecha + "\n";
    }

    mensaje += "Estado: " + estado + "\n\n";

    mensaje += "*DATOS DEL CLIENTE*\n";
    mensaje += "Nombre: " + cliente + "\n";

    if (documento) {
        mensaje += "Documento: " + documento + "\n";
    }

    if (telefonoFactura) {
        mensaje += "Teléfono: " + telefonoFactura + "\n";
    }

    if (correo) {
        mensaje += "Correo: " + correo + "\n";
    }

    if (direccion) {
        mensaje += "Dirección: " + direccion + "\n";
    }

    if (vehiculo && vehiculo !== "-") {
        mensaje += "\n*VEHÍCULO*\n";
        mensaje += vehiculo + "\n";
    }

    if (detalles.length > 0) {

        mensaje += "\n*DETALLE DE LA FACTURA*\n";

        detalles.forEach(function(detalle, indice) {

            mensaje += "\n" + (indice + 1) + ". ";
            mensaje += detalle.tipo + " - " + detalle.descripcion + "\n";
            mensaje += "Código: " + detalle.codigo + "\n";
            mensaje += "Cantidad: " + detalle.cantidad + "\n";
            mensaje += "Precio unitario: " + detalle.precio + "\n";
            mensaje += "Descuento: " + detalle.descuento + "\n";
            mensaje += "Subtotal: " + detalle.subtotal + "\n";
        });
    }

    mensaje += "\n*RESUMEN*\n";

    if (subtotal) {
        mensaje += "Subtotal: " + subtotal + "\n";
    }

    if (descuento) {
        mensaje += "Descuento: " + descuento + "\n";
    }

    if (impuesto) {
        mensaje += "Impuesto: " + impuesto + "\n";
    }

    mensaje += "*TOTAL: " + total + "*\n\n";
    mensaje += "Gracias por confiar en *Electricista Londoño*.\n";
    mensaje += "Barranquilla, Atlántico, Colombia.";

    const url =
        "https://wa.me/"
        + numero
        + "?text="
        + encodeURIComponent(mensaje);

    if (ventanaWhatsApp && !ventanaWhatsApp.closed) {
        ventanaWhatsApp.location.href = url;
    } else {
        window.location.href = url;
    }
}


function cerrarFacturaGuardada() {

    const url = "<%= request.getContextPath() %>/facturacion";
    window.location.href = url;
}


/* ==========================================================
   VER FACTURA
   ========================================================== */

function verFactura(idFactura) {

    if (!idFactura) {

        alert(
            "No se encontró el ID de la factura."
        );

        return;
    }


    const url =
        "<%= request.getContextPath() %>"
        + "/facturacion?accion=verFactura&idFactura="
        + encodeURIComponent(
            idFactura
        );


    window.location.href =
        url;
}


/* ==========================================================
   INICIALIZACIÓN
   ========================================================== */

document.addEventListener(
    "DOMContentLoaded",
    function() {

        cargarClienteInicial();

        actualizarVehiculoInicial();

        actualizarTotales();


        <% if (facturasBuscadas != null) { %>

            const buscador =
                document.getElementById(
                    "seccionBuscador"
                );


            if (buscador) {

                buscador.style.display =
                    "block";
            }

        <% } %>

    }
);


/* ==========================================================
   IMPRESIÓN DE FACTURA GUARDADA
   ========================================================== */

<% if (Boolean.TRUE.equals(imprimirFacturaGuardada) && facturaSeleccionada != null) { %>
document.addEventListener("DOMContentLoaded", function() {
    window.setTimeout(function() {
        window.print();
    }, 300);
});
<% } %>


/* ==========================================================
   CLIENTE INICIAL
   ========================================================== */

function cargarClienteInicial() {

    const select =
        document.getElementById(
            "idCliente"
        );


    if (!select
            || !select.value) {

        return;
    }


    const opcion =
        select.options[
            select.selectedIndex
        ];


    document.getElementById(
        "clienteNombre"
    ).textContent =
        opcion.dataset.nombre || "-";


    document.getElementById(
        "clienteDocumento"
    ).textContent =
        opcion.dataset.documento || "-";


    document.getElementById(
        "clienteTelefono"
    ).textContent =
        opcion.dataset.telefono || "-";


    document.getElementById(
        "clienteCorreo"
    ).textContent =
        opcion.dataset.correo || "-";


    document.getElementById(
        "clienteDireccion"
    ).textContent =
        opcion.dataset.direccion || "-";


    document.getElementById(
        "impCliente"
    ).textContent =
        opcion.dataset.nombre || "-";


    document.getElementById(
        "impDocumento"
    ).textContent =
        opcion.dataset.documento || "-";


    document.getElementById(
        "impTelefono"
    ).textContent =
        opcion.dataset.telefono || "-";


    document.getElementById(
        "impCorreo"
    ).textContent =
        opcion.dataset.correo || "-";


    document.getElementById(
        "impDireccion"
    ).textContent =
        opcion.dataset.direccion || "-";
}


/* ==========================================================
   VEHÍCULO INICIAL
   ========================================================== */

function actualizarVehiculoInicial() {

    const select =
        document.getElementById(
            "idVehiculo"
        );


    if (!select
            || !select.value
            || select.value === "0") {

        return;
    }


    actualizarVehiculo();
}

</script>


</body>

</html>