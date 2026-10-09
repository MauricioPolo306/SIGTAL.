<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.mycompany.sigtal.modelo.Producto" %>

<%
    List<Producto> productos =
            (List<Producto>) request.getAttribute("productos");
        NumberFormat formatoMoneda =
        
                NumberFormat.getCurrencyInstance(new Locale("es", "CO"));

    formatoMoneda.setMaximumFractionDigits(0);
    formatoMoneda.setMinimumFractionDigits(0);
    Producto productoEditar =
            (Producto) request.getAttribute("productoEditar");

    boolean modoEdicion =
            productoEditar != null;

    String mensaje =
            request.getParameter("mensaje");

    String error =
            request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>SIGTAL - Inventario</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f6f8;
            color: #1f2937;
        }

        .header {
            background: #111827;
            color: white;
            padding: 22px 30px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.15);
        }

        .header-contenido {
            max-width: 1400px;
            margin: auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .logo {
            font-size: 26px;
            font-weight: bold;
        }

        .subtitulo {
            color: #d1d5db;
            font-size: 14px;
            margin-top: 5px;
        }

        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .titulo {
            font-size: 30px;
            margin-bottom: 8px;
        }

        .descripcion {
            color: #6b7280;
            margin-bottom: 25px;
        }

        .card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.08);
        }

        .card h2 {
            margin-bottom: 20px;
            font-size: 21px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
        }

        .campo {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .campo label {
            font-weight: bold;
            font-size: 14px;
        }

        .campo input,
        .campo select,
        .campo textarea {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            font-size: 14px;
            outline: none;
        }

        .campo input:focus,
        .campo select:focus,
        .campo textarea:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 2px rgba(37,99,235,0.12);
        }

        .campo textarea {
            min-height: 80px;
            resize: vertical;
        }

        .campo-completo {
            grid-column: 1 / -1;
        }

        .botones {
            margin-top: 22px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-block;
            border: none;
            border-radius: 7px;
            padding: 11px 18px;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
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

        .tabla-contenedor {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1100px;
        }

        th {
            background: #111827;
            color: white;
            padding: 13px;
            text-align: left;
            font-size: 13px;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 13px;
        }

        tr:hover {
            background: #f9fafb;
        }

        .acciones {
            display: flex;
            gap: 7px;
            flex-wrap: wrap;
        }

        .acciones .btn {
            padding: 7px 11px;
            font-size: 12px;
        }

        .stock-normal {
            font-weight: bold;
        }

        .stock-bajo {
            color: #dc2626;
            font-weight: bold;
        }

        .estado {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
        }

        .estado-activo {
            background: #dcfce7;
            color: #166534;
        }

        .estado-inactivo {
            background: #fee2e2;
            color: #991b1b;
        }

        .mensaje {
            padding: 14px 18px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .mensaje-exito {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #86efac;
        }

        .mensaje-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }

        .sin-productos {
            text-align: center;
            padding: 30px;
            color: #6b7280;
        }

        .resumen {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
            margin-bottom: 25px;
        }

        .indicador {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.08);
        }

        .indicador-titulo {
            color: #6b7280;
            font-size: 13px;
            margin-bottom: 8px;
        }

        .indicador-valor {
            font-size: 28px;
            font-weight: bold;
        }

        @media (max-width: 900px) {

            .grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .resumen {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 600px) {

            .header-contenido {
                flex-direction: column;
                align-items: flex-start;
            }

            .container {
                padding: 0 12px;
            }

            .grid {
                grid-template-columns: 1fr;
            }

            .card {
                padding: 18px;
            }

            .titulo {
                font-size: 25px;
            }
        }

    </style>

</head>

<body>

<header class="header">

    <div class="header-contenido">

        <div>
            <div class="logo">
                SIGTAL
            </div>

            <div class="subtitulo">
                Sistema Integral de Gestión para Taller Automotriz
                Electricista Londoño
            </div>
        </div>

        <div>
            <strong>Inventario</strong>
        </div>

    </div>

</header>

<main class="container">

    <h1 class="titulo">
        Gestión de Inventario
    </h1>

    <p class="descripcion">
        Administración de productos, repuestos y materiales del taller.
    </p>


    <% if ("registrado".equals(mensaje)) { %>

        <div class="mensaje mensaje-exito">
            Producto registrado correctamente.
        </div>

    <% } else if ("actualizado".equals(mensaje)) { %>

        <div class="mensaje mensaje-exito">
            Producto actualizado correctamente.
        </div>

    <% } else if ("eliminado".equals(mensaje)) { %>

        <div class="mensaje mensaje-exito">
            Producto eliminado correctamente.
        </div>

    <% } %>


    <% if (error != null) { %>

        <div class="mensaje mensaje-error">

            <% if ("registro".equals(error)) { %>

                No fue posible registrar el producto.

            <% } else if ("actualizacion".equals(error)) { %>

                No fue posible actualizar el producto.

            <% } else if ("eliminacion".equals(error)) { %>

                No fue posible eliminar el producto.

            <% } else { %>

                Se produjo un error en la operación.

            <% } %>

        </div>

    <% } %>


    <%
        int totalProductos = productos != null
                ? productos.size()
                : 0;

        int productosStockBajo = 0;

        if (productos != null) {

            for (Producto producto : productos) {

                if (producto.getCantidad()
                        <= producto.getStockMinimo()) {

                    productosStockBajo++;
                }
            }
        }
    %>


    <div class="resumen">

        <div class="indicador">

            <div class="indicador-titulo">
                Productos registrados
            </div>

            <div class="indicador-valor">
                <%= totalProductos %>
            </div>

        </div>


        <div class="indicador">

            <div class="indicador-titulo">
                Productos con stock bajo
            </div>

            <div class="indicador-valor">
                <%= productosStockBajo %>
            </div>

        </div>


        <div class="indicador">

            <div class="indicador-titulo">
                Estado del inventario
            </div>

            <div class="indicador-valor">
                Activo
            </div>

        </div>

    </div>


    <div class="card">

        <h2>

            <%= modoEdicion
                    ? "Editar producto"
                    : "Registrar producto" %>

        </h2>


        <form
            method="post"
            action="<%= request.getContextPath() %>/inventario">

            <input
                type="hidden"
                name="accion"
                value="<%= modoEdicion
                        ? "actualizar"
                        : "registrar" %>">


            <% if (modoEdicion) { %>

                <input
                    type="hidden"
                    name="idProducto"
                    value="<%= productoEditar.getIdProducto() %>">

            <% } %>


            <div class="grid">

                <div class="campo">

                    <label>Código *</label>

                    <input
                        type="text"
                        name="codigo"
                        maxlength="30"
                        required
                        value="<%= modoEdicion
                                ? productoEditar.getCodigo()
                                : "" %>">

                </div>


                <div class="campo">

                    <label>Nombre *</label>

                    <input
                        type="text"
                        name="nombre"
                        maxlength="100"
                        required
                        value="<%= modoEdicion
                                ? productoEditar.getNombre()
                                : "" %>">

                </div>


                <div class="campo">

                    <label>Categoría</label>

                    <input
                        type="text"
                        name="categoria"
                        maxlength="50"
                        value="<%= modoEdicion
                                ? productoEditar.getCategoria()
                                : "" %>">

                </div>


                <div class="campo">

                    <label>Marca</label>

                    <input
                        type="text"
                        name="marca"
                        maxlength="50"
                        value="<%= modoEdicion
                                ? productoEditar.getMarca()
                                : "" %>">

                </div>


                <div class="campo">

                    <label>Cantidad *</label>

                    <input
                        type="number"
                        name="cantidad"
                        min="0"
                        required
                        value="<%= modoEdicion
                                ? productoEditar.getCantidad()
                                : "0" %>">

                </div>


                <div class="campo">

                    <label>Stock mínimo *</label>

                    <input
                        type="number"
                        name="stockMinimo"
                        min="0"
                        required
                        value="<%= modoEdicion
                                ? productoEditar.getStockMinimo()
                                : "0" %>">

                </div>


                <div class="campo">

                    <label>Precio de compra *</label>

                    <input
                        type="number"
                        name="precioCompra"
                        min="0"
                        step="0.01"
                        required
                        value="<%= modoEdicion
                                ? productoEditar.getPrecioCompra()
                                : "0.00" %>">

                </div>


                <div class="campo">

                    <label>Precio de venta *</label>

                    <input
                        type="number"
                        name="precioVenta"
                        min="0"
                        step="0.01"
                        required
                        value="<%= modoEdicion
                                ? productoEditar.getPrecioVenta()
                                : "0.00" %>">

                </div>


                <div class="campo">

                    <label>Proveedor</label>

                    <input
                        type="text"
                        name="proveedor"
                        maxlength="100"
                        value="<%= modoEdicion
                                ? productoEditar.getProveedor()
                                : "" %>">

                </div>


                <div class="campo">

                    <label>Estado</label>

                    <select name="estado">

                        <option
                            value="ACTIVO"
                            <%= modoEdicion
                                && "ACTIVO".equals(
                                    productoEditar.getEstado())
                                ? "selected"
                                : "" %>>
                            ACTIVO
                        </option>

                        <option
                            value="INACTIVO"
                            <%= modoEdicion
                                && "INACTIVO".equals(
                                    productoEditar.getEstado())
                                ? "selected"
                                : "" %>>
                            INACTIVO
                        </option>

                    </select>

                </div>


                <div class="campo campo-completo">

                    <label>Descripción</label>

                    <textarea
                        name="descripcion"
                        maxlength="255"><%= modoEdicion
                                ? productoEditar.getDescripcion()
                                : "" %></textarea>

                </div>

            </div>


            <div class="botones">

                <button
                    type="submit"
                    class="btn btn-primary">

                    <%= modoEdicion
                            ? "Actualizar producto"
                            : "Registrar producto" %>

                </button>


                <% if (modoEdicion) { %>

                    <a
                        href="<%= request.getContextPath() %>/inventario"
                        class="btn btn-secondary">

                        Cancelar

                    </a>

                <% } %>

            </div>

        </form>

    </div>


    <div class="card">

        <h2>
            Productos registrados
        </h2>


        <div class="tabla-contenedor">

            <% if (productos == null || productos.isEmpty()) { %>

                <div class="sin-productos">

                    No hay productos registrados en el inventario.

                </div>

            <% } else { %>

                <table>

                    <thead>

                        <tr>

                            <th>ID</th>
                            <th>Código</th>
                            <th>Producto</th>
                            <th>Categoría</th>
                            <th>Marca</th>
                            <th>Cantidad</th>
                            <th>Stock mínimo</th>
                            <th>Precio compra</th>
                            <th>Precio venta</th>
                            <th>Proveedor</th>
                            <th>Estado</th>
                            <th>Acciones</th>

                        </tr>

                    </thead>


                    <tbody>

                    <% for (Producto producto : productos) { %>

                        <%
                            boolean stockBajo =
                                    producto.getCantidad()
                                    <= producto.getStockMinimo();

                            boolean activo =
                                    "ACTIVO".equals(
                                            producto.getEstado());
                        %>

                        <tr>

                            <td>
                                <%= producto.getIdProducto() %>
                            </td>

                            <td>
                                <strong>
                                    <%= producto.getCodigo() %>
                                </strong>
                            </td>

                            <td>
                                <%= producto.getNombre() %>
                            </td>

                            <td>
                                <%= producto.getCategoria() != null
                                        ? producto.getCategoria()
                                        : "" %>
                            </td>

                            <td>
                                <%= producto.getMarca() != null
                                        ? producto.getMarca()
                                        : "" %>
                            </td>

                            <td>

                                <span class="<%= stockBajo
                                        ? "stock-bajo"
                                        : "stock-normal" %>">

                                    <%= producto.getCantidad() %>

                                    <% if (stockBajo) { %>
                                        ?
                                    <% } %>

                                </span>

                            </td>

                            <td>
                                <%= producto.getStockMinimo() %>
                            </td>

                            <td>
                                <%= formatoMoneda.format(producto.getPrecioCompra()) %>
                            </td>

                            <td>
                               <%= formatoMoneda.format(producto.getPrecioVenta()) %>
                            </td>

                            <td>
                                <%= producto.getProveedor() != null
                                        ? producto.getProveedor()
                                        : "" %>
                            </td>

                            <td>

                                <span class="estado <%= activo
                                        ? "estado-activo"
                                        : "estado-inactivo" %>">

                                    <%= producto.getEstado() %>

                                </span>

                            </td>

                            <td>

                                <div class="acciones">

                                    <a
                                        href="<%= request.getContextPath() %>/inventario?accion=editar&id=<%= producto.getIdProducto() %>"
                                        class="btn btn-edit">

                                        Editar

                                    </a>


                                    <a
                                        href="<%= request.getContextPath() %>/inventario?accion=eliminar&id=<%= producto.getIdProducto() %>"
                                        class="btn btn-delete"
                                        onclick="return confirm('¿Está seguro de eliminar este producto?');">

                                        Eliminar

                                    </a>

                                </div>

                            </td>

                        </tr>

                    <% } %>

                    </tbody>

                </table>

            <% } %>

        </div>

    </div>

</main>

</body>

</html>