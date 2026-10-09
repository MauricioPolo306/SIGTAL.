<%@page import="java.util.List"%>
<%@page import="com.mycompany.sigtal.modelo.Cliente"%>
<%@page import="com.mycompany.sigtal.modelo.Vehiculo"%>

<%
List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
Cliente clienteEditar = (Cliente) request.getAttribute("clienteEditar");
Cliente clienteSeleccionado = (Cliente) request.getAttribute("clienteSeleccionado");
List<Vehiculo> vehiculos = (List<Vehiculo>) request.getAttribute("vehiculos");

Vehiculo vehiculoEditar = (Vehiculo) request.getAttribute("vehiculoEditar");

boolean modoEdicionCliente = clienteEditar != null;
boolean modoEdicionVehiculo = vehiculoEditar != null;
boolean hayClienteSeleccionado = clienteSeleccionado != null;

%>

<!DOCTYPE html>

<html lang="es">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Clientes y Vehículos | SIGTAL</title>

<style>

    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    body {
        font-family: Arial, Helvetica, sans-serif;
        background: #f3f4f6;
        color: #1f2937;
    }

    .header {
        background: #111827;
        color: white;
        padding: 20px 30px;

        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .header h1 {
        font-size: 25px;
        margin-bottom: 5px;
    }

    .header span {
        color: #d1d5db;
        font-size: 14px;
    }

    .container {
        width: 95%;
        max-width: 1450px;
        margin: 30px auto;
    }

    .titulo {
        margin-bottom: 25px;
    }

    .titulo h2 {
        font-size: 30px;
        margin-bottom: 7px;
    }

    .titulo p {
        color: #6b7280;
    }

    .card {
        background: white;
        border-radius: 12px;
        padding: 25px;

        box-shadow:
            0 4px 15px rgba(0, 0, 0, 0.08);

        margin-bottom: 25px;
    }

    .card h3 {
        font-size: 20px;
        margin-bottom: 20px;
    }

    .grid-clientes {
        display: grid;
        grid-template-columns: 350px 1fr;
        gap: 25px;
    }

    .campo {
        margin-bottom: 15px;
    }

    .campo label {
        display: block;
        font-size: 14px;
        font-weight: bold;
        margin-bottom: 6px;
    }

    .campo input,
    .campo select {
        width: 100%;

        padding: 11px;

        border: 1px solid #d1d5db;
        border-radius: 7px;

        font-size: 14px;
    }

    .campo input:focus,
    .campo select:focus {
        outline: none;
        border-color: #2563eb;
    }

    .botones {
        display: flex;
        gap: 10px;
        margin-top: 20px;
        flex-wrap: wrap;
    }

    .btn {
        border: none;
        border-radius: 7px;

        padding: 10px 15px;

        cursor: pointer;

        text-decoration: none;

        font-size: 13px;
        font-weight: bold;

        display: inline-block;
    }

    .btn-primary {
        background: #2563eb;
        color: white;
    }

    .btn-primary:hover {
        background: #1d4ed8;
    }

    .btn-secondary {
        background: #6b7280;
        color: white;
    }

    .btn-secondary:hover {
        background: #4b5563;
    }

    .btn-edit {
        background: #f59e0b;
        color: white;
    }

    .btn-edit:hover {
        background: #d97706;
    }

    .btn-delete {
        background: #dc2626;
        color: white;
    }

    .btn-delete:hover {
        background: #b91c1c;
    }

    .btn-select {
        background: #059669;
        color: white;
    }

    .btn-select:hover {
        background: #047857;
    }

    .tabla-contenedor {
        overflow-x: auto;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    thead {
        background: #111827;
        color: white;
    }

    th,
    td {
        padding: 13px 10px;

        text-align: left;

        border-bottom:
            1px solid #e5e7eb;

        font-size: 14px;
    }

    tbody tr:hover {
        background: #f9fafb;
    }

    .acciones {
        display: flex;
        gap: 6px;
        flex-wrap: wrap;
    }

    .acciones .btn {
        padding: 8px 10px;
        font-size: 12px;
    }

    .cliente-seleccionado {
        border-left: 5px solid #2563eb;
        background: #eff6ff;
        padding: 18px;

        border-radius: 8px;

        margin-bottom: 20px;
    }

    .cliente-seleccionado h4 {
        font-size: 18px;
        margin-bottom: 8px;
    }

    .cliente-datos {
        display: flex;
        gap: 20px;
        flex-wrap: wrap;
    }

    .cliente-datos span {
        font-size: 14px;
        color: #374151;
    }

    .vehiculos-grid {
        display: grid;

        grid-template-columns:
            350px 1fr;

        gap: 25px;
    }

    .vehiculo-form {
        background: #f9fafb;

        border: 1px solid #e5e7eb;

        border-radius: 10px;

        padding: 20px;
    }

    .vehiculo-form h4 {
        margin-bottom: 18px;
        font-size: 18px;
    }

    .vehiculo-tabla {
        overflow-x: auto;
    }

    .sin-registros {
        text-align: center;

        padding: 30px;

        color: #6b7280;
    }

    .mensaje {
        padding: 13px 16px;

        border-radius: 7px;

        margin-bottom: 20px;

        background: #dcfce7;

        color: #166534;

        border-left:
            5px solid #16a34a;
    }

    .advertencia {
        padding: 15px;

        border-radius: 8px;

        background: #fff7ed;

        color: #9a3412;

        border-left:
            5px solid #f97316;

        margin-bottom: 20px;
    }

    .modo-edicion {
        background: #fff7ed;

        border-left:
            5px solid #f59e0b;

        padding: 12px;

        margin-bottom: 20px;

        border-radius: 5px;

        font-size: 14px;
    }

    .modo-edicion-vehiculo {
        background: #fef3c7;

        border-left:
            5px solid #f59e0b;

        padding: 12px;

        margin-bottom: 18px;

        border-radius: 6px;

        font-size: 14px;

        color: #92400e;
    }

    @media (max-width: 1000px) {

        .grid-clientes {
            grid-template-columns: 1fr;
        }

        .vehiculos-grid {
            grid-template-columns: 1fr;
        }

    }

    @media (max-width: 700px) {

        .header {
            flex-direction: column;

            align-items: flex-start;

            gap: 8px;
        }

        .container {
            width: 92%;
        }

        .card {
            padding: 18px;
        }

        th,
        td {
            font-size: 12px;
        }

    }

</style>

</head>

<body>

<header class="header">

<div>

    <h1>SIGTAL</h1>

    <span>
        Sistema Integral de Gestión para Taller Automotriz
    </span>

</div>

<span>
    Clientes y Vehículos
</span>

</header>

<main class="container">

<div class="titulo">

    <h2>
        Clientes y Vehículos
    </h2>

    <p>
        Administración de clientes y de los vehículos asociados
        al taller automotriz.
    </p>

</div>


<!-- =================================================
     MENSAJES
     ================================================= -->

<%
    String mensaje = request.getParameter("mensaje");
    String error = request.getParameter("error");

    if (mensaje != null) {
%>

    <div class="mensaje">

        <%
            if ("registrado".equals(mensaje)) {
        %>

            Cliente registrado correctamente.

        <%
            } else if ("actualizado".equals(mensaje)) {
        %>

            Cliente actualizado correctamente.

        <%
            } else if ("eliminado".equals(mensaje)) {
        %>

            Cliente eliminado correctamente.

        <%
            } else if ("vehiculoRegistrado".equals(mensaje)) {
        %>

            Vehículo registrado correctamente.

        <%
            } else if ("vehiculoActualizado".equals(mensaje)) {
        %>

            Vehículo actualizado correctamente.

        <%
            } else if ("vehiculoEliminado".equals(mensaje)) {
        %>

            Vehículo eliminado correctamente.

        <%
            } else {
        %>

            Operación realizada correctamente.

        <%
            }
        %>

    </div>

<%
    }

    if (error != null) {
%>

    <div class="advertencia">

        Ya existe un vehiculo con esta placa.

    </div>

<%
    }
%>


<!-- =================================================
     CLIENTES
     ================================================= -->

<div class="grid-clientes">


    <!-- FORMULARIO CLIENTE -->

    <section class="card">

        <h3>

            <%= modoEdicionCliente
                    ? "Editar cliente"
                    : "Registrar cliente" %>

        </h3>


        <% if (modoEdicionCliente) { %>

            <div class="modo-edicion">

                Editando el cliente:

                <strong>
                    <%= clienteEditar.getNombre() %>
                </strong>

            </div>

        <% } %>


        <form
            action="<%= request.getContextPath() %>/clientes"
            method="post">

            <input
                type="hidden"
                name="accion"
                value="<%= modoEdicionCliente
                        ? "actualizar"
                        : "registrar" %>">


            <% if (modoEdicionCliente) { %>

                <input
                    type="hidden"
                    name="idCliente"
                    value="<%= clienteEditar.getIdCliente() %>">

            <% } %>


            <div class="campo">

                <label for="nombre">
                    Nombre completo
                </label>

                <input
                    type="text"
                    id="nombre"
                    name="nombre"
                    required
                    value="<%= modoEdicionCliente
                            ? clienteEditar.getNombre()
                            : "" %>"
                    placeholder="Ingrese el nombre completo">

            </div>


            <div class="campo">

                <label for="documento">
                    Documento
                </label>

                <input
                    type="text"
                    id="documento"
                    name="documento"
                    required
                    value="<%= modoEdicionCliente
                            ? clienteEditar.getDocumento()
                            : "" %>"
                    placeholder="Número de documento">

            </div>


            <div class="campo">

                <label for="telefono">
                    Teléfono
                </label>

                <input
                    type="text"
                    id="telefono"
                    name="telefono"
                    value="<%= modoEdicionCliente
                            ? clienteEditar.getTelefono()
                            : "" %>"
                    placeholder="Número de teléfono">

            </div>


            <div class="campo">

                <label for="correo">
                    Correo electrónico
                </label>

                <input
                    type="email"
                    id="correo"
                    name="correo"
                    value="<%= modoEdicionCliente
                            ? clienteEditar.getCorreo()
                            : "" %>"
                    placeholder="correo@ejemplo.com">

            </div>


            <div class="campo">

                <label for="direccion">
                    Dirección
                </label>

                <input
                    type="text"
                    id="direccion"
                    name="direccion"
                    value="<%= modoEdicionCliente
                            ? clienteEditar.getDireccion()
                            : "" %>"
                    placeholder="Dirección de residencia">

            </div>


            <div class="botones">

                <button
                    type="submit"
                    class="btn btn-primary">

                    <%= modoEdicionCliente
                            ? "Actualizar cliente"
                            : "Registrar cliente" %>

                </button>


                <% if (modoEdicionCliente) { %>

                    <a
                        href="<%= request.getContextPath() %>/clientes"
                        class="btn btn-secondary">

                        Cancelar

                    </a>

                <% } %>

            </div>

        </form>

    </section>


    <!-- TABLA CLIENTES -->

    <section class="card">

        <h3>
            Clientes registrados
        </h3>

        <div class="tabla-contenedor">

            <table>

                <thead>

                    <tr>

                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Documento</th>
                        <th>Teléfono</th>
                        <th>Correo</th>
                        <th>Acciones</th>

                    </tr>

                </thead>

                <tbody>

                <% if (clientes != null && !clientes.isEmpty()) { %>

                    <% for (Cliente cliente : clientes) { %>

                        <tr>

                            <td>
                                <%= cliente.getIdCliente() %>
                            </td>

                            <td>
                                <strong>
                                    <%= cliente.getNombre() %>
                                </strong>
                            </td>

                            <td>
                                <%= cliente.getDocumento() %>
                            </td>

                            <td>
                                <%= cliente.getTelefono() != null
                                        ? cliente.getTelefono()
                                        : "" %>
                            </td>

                            <td>
                                <%= cliente.getCorreo() != null
                                        ? cliente.getCorreo()
                                        : "" %>
                            </td>

                            <td>

                                <div class="acciones">

                                    <a
                                        href="<%= request.getContextPath() %>/clientes?idCliente=<%= cliente.getIdCliente() %>"
                                        class="btn btn-select">

                                        Vehículos

                                    </a>


                                    <a
                                        href="<%= request.getContextPath() %>/clientes?accion=editar&id=<%= cliente.getIdCliente() %>"
                                        class="btn btn-edit">

                                        Editar

                                    </a>


                                    <a
                                        href="<%= request.getContextPath() %>/clientes?accion=eliminar&id=<%= cliente.getIdCliente() %>"
                                        class="btn btn-delete"
                                        onclick="return confirmarEliminacion();">

                                        Eliminar

                                    </a>

                                </div>

                            </td>

                        </tr>

                    <% } %>

                <% } else { %>

                    <tr>

                        <td
                            colspan="6"
                            class="sin-registros">

                            No hay clientes registrados.

                        </td>

                    </tr>

                <% } %>

                </tbody>

            </table>

        </div>

    </section>

</div>


<!-- =================================================
     CLIENTE SELECCIONADO + VEHICULOS
     ================================================= -->

<% if (hayClienteSeleccionado) { %>

    <section class="card">

        <h3>
            Vehículos del cliente
        </h3>


        <!-- DATOS CLIENTE -->

        <div class="cliente-seleccionado">

            <h4>
                <%= clienteSeleccionado.getNombre() %>
            </h4>

            <div class="cliente-datos">

                <span>

                    <strong>Documento:</strong>

                    <%= clienteSeleccionado.getDocumento() %>

                </span>

                <span>

                    <strong>Teléfono:</strong>

                    <%= clienteSeleccionado.getTelefono() != null
                            ? clienteSeleccionado.getTelefono()
                            : "No registrado" %>

                </span>

                <span>

                    <strong>Correo:</strong>

                    <%= clienteSeleccionado.getCorreo() != null
                            ? clienteSeleccionado.getCorreo()
                            : "No registrado" %>

                </span>

                <span>

                    <strong>Dirección:</strong>

                    <%= clienteSeleccionado.getDireccion() != null
                            ? clienteSeleccionado.getDireccion()
                            : "No registrada" %>

                </span>

            </div>

        </div>


        <div class="vehiculos-grid">


            <!-- =====================================
                 FORMULARIO VEHICULO
                 ===================================== -->

            <div class="vehiculo-form">

                <h4>

                    <%= modoEdicionVehiculo
                            ? "Editar vehículo"
                            : "Registrar vehículo" %>

                </h4>


                <% if (modoEdicionVehiculo) { %>

                    <div class="modo-edicion-vehiculo">

                        Editando vehículo:

                        <strong>
                            <%= vehiculoEditar.getPlaca() %>
                        </strong>

                    </div>

                <% } %>


                <form
                    action="<%= request.getContextPath() %>/vehiculos"
                    method="post">


                    <input
                        type="hidden"
                        name="accion"
                        value="<%= modoEdicionVehiculo
                                ? "actualizar"
                                : "registrar" %>">


                    <% if (modoEdicionVehiculo) { %>

                        <input
                            type="hidden"
                            name="idVehiculo"
                            value="<%= vehiculoEditar.getIdVehiculo() %>">

                    <% } %>


                    <input
                        type="hidden"
                        name="idCliente"
                        value="<%= clienteSeleccionado.getIdCliente() %>">


                    <!-- PLACA -->

                    <div class="campo">

                        <label for="placa">
                            Placa
                        </label>

                        <input
                            type="text"
                            id="placa"
                            name="placa"
                            required
                            maxlength="10"
                            value="<%= modoEdicionVehiculo
                                    ? vehiculoEditar.getPlaca()
                                    : "" %>"
                            placeholder="Ej: ABC123">

                    </div>


                    <!-- MARCA -->

                    <div class="campo">

                        <label for="marca">
                            Marca
                        </label>

                        <input
                            type="text"
                            id="marca"
                            name="marca"
                            required
                            value="<%= modoEdicionVehiculo
                                    ? vehiculoEditar.getMarca()
                                    : "" %>"
                            placeholder="Ej: Chevrolet">

                    </div>


                    <!-- MODELO -->

                    <div class="campo">

                        <label for="modelo">
                            Modelo
                        </label>

                        <input
                            type="text"
                            id="modelo"
                            name="modelo"
                            value="<%= modoEdicionVehiculo
                                    && vehiculoEditar.getModelo() != null
                                    ? vehiculoEditar.getModelo()
                                    : "" %>"
                            placeholder="Ej: Spark">

                    </div>


                    <!-- AÑO -->

                    <div class="campo">

                        <label for="anio">
                            Año
                        </label>

                        <input
                            type="number"
                            id="anio"
                            name="anio"
                            min="1900"
                            max="2100"
                            value="<%= modoEdicionVehiculo
                                    && vehiculoEditar.getAnio() != null
                                    ? vehiculoEditar.getAnio()
                                    : "" %>"
                            placeholder="Ej: 2020">

                    </div>


                    <!-- COLOR -->

                    <div class="campo">

                        <label for="color">
                            Color
                        </label>

                        <input
                            type="text"
                            id="color"
                            name="color"
                            value="<%= modoEdicionVehiculo
                                    && vehiculoEditar.getColor() != null
                                    ? vehiculoEditar.getColor()
                                    : "" %>"
                            placeholder="Ej: Blanco">

                    </div>


                    <!-- TIPO -->

                    <div class="campo">

                        <label for="tipoVehiculo">
                            Tipo de vehículo
                        </label>

                        <select
                            id="tipoVehiculo"
                            name="tipoVehiculo">

                            <option value="">
                                Seleccione
                            </option>

                            <option
                                value="Automovil"
                                <%= modoEdicionVehiculo
                                        && "Automovil".equals(vehiculoEditar.getTipoVehiculo())
                                        ? "selected"
                                        : "" %>>

                                Automovil

                            </option>

                            <option
                                value="Camioneta"
                                <%= modoEdicionVehiculo
                                        && "Camioneta".equals(vehiculoEditar.getTipoVehiculo())
                                        ? "selected"
                                        : "" %>>

                                Camioneta

                            </option>

                            <option
                                value="Motocicleta"
                                <%= modoEdicionVehiculo
                                        && "Motocicleta".equals(vehiculoEditar.getTipoVehiculo())
                                        ? "selected"
                                        : "" %>>

                                Motocicleta

                            </option>

                            <option
                                value="Camión"
                                <%= modoEdicionVehiculo
                                        && "Camión".equals(vehiculoEditar.getTipoVehiculo())
                                        ? "selected"
                                        : "" %>>

                                Camión

                            </option>

                            <option
                                value="Otro"
                                <%= modoEdicionVehiculo
                                        && "Otro".equals(vehiculoEditar.getTipoVehiculo())
                                        ? "selected"
                                        : "" %>>

                                Otro

                            </option>

                        </select>

                    </div>


                    <div class="botones">

                        <button
                            type="submit"
                            class="btn btn-primary">

                            <%= modoEdicionVehiculo
                                    ? "Actualizar vehículo"
                                    : "Registrar vehículo" %>

                        </button>


                        <% if (modoEdicionVehiculo) { %>

                            <a
                                href="<%= request.getContextPath() %>/clientes?idCliente=<%= clienteSeleccionado.getIdCliente() %>"
                                class="btn btn-secondary">

                                Cancelar

                            </a>

                        <% } %>

                    </div>

                </form>

            </div>


            <!-- =====================================
                 TABLA VEHICULOS
                 ===================================== -->

            <div>

                <h4 style="margin-bottom: 15px;">

                    Vehículos registrados

                </h4>


                <div class="vehiculo-tabla">

                    <table>

                        <thead>

                            <tr>

                                <th>Placa</th>
                                <th>Marca</th>
                                <th>Modelo</th>
                                <th>Año</th>
                                <th>Color</th>
                                <th>Tipo</th>
                                <th>Acciones</th>

                            </tr>

                        </thead>


                        <tbody>

                        <% if (vehiculos != null && !vehiculos.isEmpty()) { %>

                            <% for (Vehiculo vehiculo : vehiculos) { %>

                                <tr>

                                    <td>

                                        <strong>
                                            <%= vehiculo.getPlaca() %>
                                        </strong>

                                    </td>

                                    <td>
                                        <%= vehiculo.getMarca() %>
                                    </td>

                                    <td>

                                        <%= vehiculo.getModelo() != null
                                                ? vehiculo.getModelo()
                                                : "" %>

                                    </td>

                                    <td>

                                        <%= vehiculo.getAnio() != null
                                                ? vehiculo.getAnio()
                                                : "" %>

                                    </td>

                                    <td>

                                        <%= vehiculo.getColor() != null
                                                ? vehiculo.getColor()
                                                : "" %>

                                    </td>

                                    <td>

                                        <%= vehiculo.getTipoVehiculo() != null
                                                ? vehiculo.getTipoVehiculo()
                                                : "" %>

                                    </td>

                                    <td>

                                        <div class="acciones">

                                            <a
                                                href="<%= request.getContextPath() %>/vehiculos?accion=editar&id=<%= vehiculo.getIdVehiculo() %>"
                                                class="btn btn-edit">

                                                Editar

                                            </a>


                                            <a
                                                href="<%= request.getContextPath() %>/vehiculos?accion=eliminar&id=<%= vehiculo.getIdVehiculo() %>&idCliente=<%= clienteSeleccionado.getIdCliente() %>"
                                                class="btn btn-delete"
                                                onclick="return confirmarEliminacionVehiculo();">

                                                Eliminar

                                            </a>

                                        </div>

                                    </td>

                                </tr>

                            <% } %>

                        <% } else { %>

                            <tr>

                                <td
                                    colspan="7"
                                    class="sin-registros">

                                    Este cliente no tiene vehículos registrados.

                                </td>

                            </tr>

                        <% } %>

                        </tbody>

                    </table>

                </div>

            </div>

        </div>

    </section>


<% } else { %>


    <section class="card">

        <div class="advertencia">

            <strong>
                Seleccione un cliente
            </strong>

            <br>

            Utilice el botón
            <strong>Vehículos</strong>
            de la tabla de clientes para consultar
            y registrar los vehículos asociados.

        </div>

    </section>


<% } %>

</main>

<script>

    function confirmarEliminacion() {

        return confirm(
            "¿Está seguro de eliminar este cliente?"
        );

    }


    function confirmarEliminacionVehiculo() {

        return confirm(
            "¿Está seguro de eliminar este vehículo?"
        );

    }

</script>

</body>

</html>