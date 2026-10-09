package com.mycompany.sigtal.controlador;

import com.mycompany.sigtal.dao.ClienteDAO;
import com.mycompany.sigtal.dao.FacturaDAO;
import com.mycompany.sigtal.dao.InventarioDAO;
import com.mycompany.sigtal.dao.VehiculoDAO;

import com.mycompany.sigtal.modelo.Cliente;
import com.mycompany.sigtal.modelo.DetalleFactura;
import com.mycompany.sigtal.modelo.Factura;
import com.mycompany.sigtal.modelo.Producto;
import com.mycompany.sigtal.modelo.Vehiculo;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/facturacion")
public class FacturacionServlet extends HttpServlet {

    private final ClienteDAO clienteDAO = new ClienteDAO();
    private final VehiculoDAO vehiculoDAO = new VehiculoDAO();
    private final InventarioDAO inventarioDAO = new InventarioDAO();
    private final FacturaDAO facturaDAO = new FacturaDAO();


    // ============================================================
    // GET
    // ============================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {

            // ====================================================
            // CLIENTES
            // ====================================================

            List<Cliente> clientes =
                    clienteDAO.listar();

            request.setAttribute(
                    "clientes",
                    clientes
            );


            // ====================================================
            // PRODUCTOS
            // ====================================================

            List<Producto> productos =
                    inventarioDAO.listar();

            request.setAttribute(
                    "productos",
                    productos
            );


            // ====================================================
            // VEHÍCULOS DEL CLIENTE
            // ====================================================

            String idClienteParametro =
                    request.getParameter("idCliente");

            if (idClienteParametro != null
                    && !idClienteParametro.isBlank()) {

                try {

                    int idCliente =
                            Integer.parseInt(
                                    idClienteParametro
                            );

                    List<Vehiculo> vehiculos =
                            vehiculoDAO.listarPorCliente(
                                    idCliente
                            );

                    request.setAttribute(
                            "vehiculos",
                            vehiculos
                    );

                    request.setAttribute(
                            "clienteSeleccionado",
                            idCliente
                    );

                    Cliente clienteSeleccionado =
                            clienteDAO.buscarPorId(
                                    idCliente
                            );

                    request.setAttribute(
                            "clienteSeleccionadoObjeto",
                            clienteSeleccionado
                    );

                } catch (NumberFormatException e) {

                    request.setAttribute(
                            "error",
                            "El ID del cliente no es válido."
                    );
                }
            }


            // ====================================================
            // MENSAJE
            // ====================================================

            String mensaje =
                    request.getParameter("mensaje");

            if (mensaje != null
                    && !mensaje.isBlank()) {

                request.setAttribute(
                        "mensaje",
                        mensaje
                );
            }


            // ====================================================
            // NÚMERO DE FACTURA
            // ====================================================

            String numeroFactura =
                    request.getParameter("numeroFactura");

            if (numeroFactura != null
                    && !numeroFactura.isBlank()) {

                request.setAttribute(
                        "numeroFactura",
                        numeroFactura
                );
            }


            // ====================================================
            // ACCIÓN
            // ====================================================

            String accion =
                    request.getParameter("accion");


            // ====================================================
            // BUSCAR FACTURAS
            // ====================================================

            if ("buscarFacturas".equals(accion)) {

                String texto =
                        request.getParameter(
                                "busqueda"
                        );

                String estado =
                        request.getParameter(
                                "estadoBusqueda"
                        );

                String fechaDesde =
                        request.getParameter(
                                "fechaDesde"
                        );

                String fechaHasta =
                        request.getParameter(
                                "fechaHasta"
                        );


                List<Map<String, Object>> facturas =
                        facturaDAO.buscarFacturas(
                                texto,
                                estado,
                                fechaDesde,
                                fechaHasta
                        );


                request.setAttribute(
                        "facturasBuscadas",
                        facturas
                );

                request.setAttribute(
                        "busqueda",
                        texto
                );

                request.setAttribute(
                        "estadoBusqueda",
                        estado
                );

                request.setAttribute(
                        "fechaDesde",
                        fechaDesde
                );

                request.setAttribute(
                        "fechaHasta",
                        fechaHasta
                );
            }


            // ====================================================
            // VER / IMPRIMIR FACTURA
            // ====================================================

            if ("verFactura".equals(accion)
                    || "imprimirFactura".equals(accion)) {

                String idFacturaTexto =
                        request.getParameter(
                                "idFactura"
                        );

                if (idFacturaTexto != null
                        && !idFacturaTexto.isBlank()) {

                    try {

                        int idFactura =
                                Integer.parseInt(
                                        idFacturaTexto
                                );


                        Map<String, Object>
                                facturaSeleccionada =
                                facturaDAO.buscarFacturaCompleta(
                                        idFactura
                                );


                        List<Map<String, Object>>
                                detallesSeleccionados =
                                facturaDAO.obtenerDetallesFactura(
                                        idFactura
                                );


                        if (facturaSeleccionada == null) {

                            request.setAttribute(
                                    "error",
                                    "No se encontró la factura."
                            );

                        } else {

                            request.setAttribute(
                                    "facturaSeleccionada",
                                    facturaSeleccionada
                            );

                            request.setAttribute(
                                    "detallesSeleccionados",
                                    detallesSeleccionados
                            );


                            if ("imprimirFactura".equals(
                                    accion)) {

                                request.setAttribute(
                                        "imprimirFacturaGuardada",
                                        true
                                );
                            }
                        }

                    } catch (NumberFormatException e) {

                        request.setAttribute(
                                "error",
                                "El ID de la factura no es válido."
                        );
                    }
                }
            }


            // ====================================================
            // MOSTRAR JSP
            // ====================================================

            request.getRequestDispatcher(
                    "/facturacion.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Error al cargar el módulo de facturación: "
                    + e.getMessage()
            );

            request.getRequestDispatcher(
                    "/facturacion.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }


    // ============================================================
    // POST
    // ============================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String accion =
                request.getParameter("accion");


        if (accion == null
                || accion.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/facturacion"
            );

            return;
        }


        try {

            switch (accion) {

                case "registrar":

                    registrarFactura(
                            request,
                            response
                    );

                    break;


                case "eliminar":

                    eliminarFactura(
                            request,
                            response
                    );

                    break;


                default:

                    response.sendRedirect(
                            request.getContextPath()
                            + "/facturacion"
                    );

                    break;
            }


        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Error en facturación: "
                    + e.getMessage()
            );

            doGet(
                    request,
                    response
            );
        }
    }


    // ============================================================
    // REGISTRAR FACTURA
    // ============================================================

    private void registrarFactura(
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {


        // ========================================================
        // CLIENTE
        // ========================================================

        String idClienteTexto =
                request.getParameter(
                        "idCliente"
                );


        if (idClienteTexto == null
                || idClienteTexto.isBlank()) {

            throw new Exception(
                    "Debe seleccionar un cliente."
            );
        }


        int idCliente =
                Integer.parseInt(
                        idClienteTexto
                );


        // ========================================================
        // VEHÍCULO
        // ========================================================

        String idVehiculoParametro =
                request.getParameter(
                        "idVehiculo"
                );


        Integer idVehiculo = null;


        if (idVehiculoParametro != null
                && !idVehiculoParametro.isBlank()
                && !"0".equals(
                        idVehiculoParametro
                )) {

            idVehiculo =
                    Integer.parseInt(
                            idVehiculoParametro
                    );
        }


        // ========================================================
        // TOTALES
        // ========================================================

        BigDecimal subtotal =
                obtenerDecimal(
                        request.getParameter(
                                "subtotal"
                        )
                );


        BigDecimal descuento =
                obtenerDecimal(
                        request.getParameter(
                                "descuento"
                        )
                );


        BigDecimal impuesto =
                obtenerDecimal(
                        request.getParameter(
                                "impuesto"
                        )
                );


        BigDecimal total =
                obtenerDecimal(
                        request.getParameter(
                                "total"
                        )
                );


        // ========================================================
        // ESTADO
        // ========================================================

        String estado =
                request.getParameter(
                        "estado"
                );


        if (estado == null
                || estado.isBlank()) {

            estado = "PENDIENTE";
        }


        // ========================================================
        // CREAR FACTURA
        // ========================================================

        Factura factura =
                new Factura(
                        null,
                        idCliente,
                        idVehiculo,
                        LocalDateTime.now(),
                        subtotal,
                        descuento,
                        impuesto,
                        total,
                        estado
                );


        // ========================================================
        // DETALLES
        // ========================================================

        List<DetalleFactura> detalles =
                new ArrayList<>();


        String[] idProductos =
                request.getParameterValues(
                        "idProducto"
                );


        String[] descripciones =
                request.getParameterValues(
                        "descripcion"
                );


        String[] cantidades =
                request.getParameterValues(
                        "cantidad"
                );


        String[] precios =
                request.getParameterValues(
                        "precioUnitario"
                );


        String[] descuentos =
                request.getParameterValues(
                        "descuentoDetalle"
                );


        // ========================================================
        // RECORRER DETALLES
        // ========================================================

        if (descripciones != null) {

            for (int i = 0;
                 i < descripciones.length;
                 i++) {

                String descripcion =
                        descripciones[i];


                if (descripcion == null
                        || descripcion.isBlank()) {

                    continue;
                }


                // ------------------------------------------------
                // PRODUCTO
                // ------------------------------------------------

                Integer idProducto = null;


                if (idProductos != null
                        && i < idProductos.length
                        && idProductos[i] != null
                        && !idProductos[i].isBlank()
                        && !"0".equals(
                                idProductos[i]
                        )) {

                    idProducto =
                            Integer.parseInt(
                                    idProductos[i]
                            );
                }


                // ------------------------------------------------
                // CANTIDAD
                // ------------------------------------------------

                int cantidad = 1;


                if (cantidades != null
                        && i < cantidades.length
                        && cantidades[i] != null
                        && !cantidades[i].isBlank()) {

                    cantidad =
                            Integer.parseInt(
                                    cantidades[i]
                            );
                }


                if (cantidad <= 0) {

                    cantidad = 1;
                }


                // ------------------------------------------------
                // PRECIO
                // ------------------------------------------------

                BigDecimal precioUnitario =
                        obtenerDecimal(
                                precios != null
                                && i < precios.length
                                ? precios[i]
                                : null
                        );


                // ------------------------------------------------
                // DESCUENTO
                // ------------------------------------------------

                BigDecimal descuentoDetalle =
                        obtenerDecimal(
                                descuentos != null
                                && i < descuentos.length
                                ? descuentos[i]
                                : null
                        );


                // ------------------------------------------------
                // SUBTOTAL
                // ------------------------------------------------

                BigDecimal subtotalDetalle =
                        precioUnitario
                                .multiply(
                                        BigDecimal.valueOf(
                                                cantidad
                                        )
                                )
                                .subtract(
                                        descuentoDetalle
                                );


                if (subtotalDetalle.compareTo(
                        BigDecimal.ZERO
                ) < 0) {

                    subtotalDetalle =
                            BigDecimal.ZERO;
                }


                // ------------------------------------------------
                // DETALLE
                // ------------------------------------------------

                DetalleFactura detalle =
                        new DetalleFactura(
                                0,
                                idProducto,
                                descripcion,
                                cantidad,
                                precioUnitario,
                                descuentoDetalle,
                                subtotalDetalle
                        );


                detalles.add(
                        detalle
                );
            }
        }


        // ========================================================
        // VALIDAR DETALLES
        // ========================================================

        if (detalles.isEmpty()) {

            throw new Exception(
                    "La factura debe tener al menos "
                    + "un producto o servicio."
            );
        }


        // ========================================================
        // GUARDAR FACTURA
        // ========================================================

        int idFactura =
                facturaDAO.registrar(
                        factura,
                        detalles
                );


        if (idFactura <= 0) {

            throw new Exception(
                    "No fue posible registrar la factura. "
                    + "Verifique los datos y el stock disponible."
            );
        }


        // ========================================================
        // NÚMERO DE FACTURA
        // ========================================================

        String numeroGenerado =
                factura.getNumeroFactura();


        if (numeroGenerado == null
                || numeroGenerado.isBlank()) {

            numeroGenerado =
                    String.valueOf(
                            idFactura
                    );
        }


        // ========================================================
        // MENSAJE
        // ========================================================

        String mensaje =
                "Factura "
                + numeroGenerado
                + " registrada correctamente";


        // ========================================================
        // REDIRECCIÓN
        // ========================================================

        response.sendRedirect(
                request.getContextPath()
                + "/facturacion?mensaje="
                + URLEncoder.encode(
                        mensaje,
                        "UTF-8"
                )
                + "&numeroFactura="
                + URLEncoder.encode(
                        numeroGenerado,
                        "UTF-8"
                )
        );
    }


    // ============================================================
    // ELIMINAR FACTURA
    // ============================================================

    private void eliminarFactura(
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {


        String idFacturaTexto =
                request.getParameter(
                        "idFactura"
                );


        if (idFacturaTexto == null
                || idFacturaTexto.isBlank()) {

            throw new Exception(
                    "No se recibió el ID de la factura."
            );
        }


        int idFactura =
                Integer.parseInt(
                        idFacturaTexto
                );


        if (idFactura <= 0) {

            throw new Exception(
                    "El ID de la factura no es válido."
            );
        }


        // ========================================================
        // ELIMINAR
        // ========================================================

        boolean eliminado =
                facturaDAO.eliminar(
                        idFactura
                );


        if (!eliminado) {

            throw new Exception(
                    "No fue posible eliminar la factura."
            );
        }


        // ========================================================
        // REDIRECCIÓN
        // ========================================================

        String mensaje =
                "Factura eliminada correctamente";


        response.sendRedirect(
                request.getContextPath()
                + "/facturacion?mensaje="
                + URLEncoder.encode(
                        mensaje,
                        "UTF-8"
                )
        );
    }


    // ============================================================
    // CONVERTIR TEXTO A BIGDECIMAL
    // ============================================================

    private BigDecimal obtenerDecimal(
            String valor) {

        if (valor == null
                || valor.isBlank()) {

            return BigDecimal.ZERO;
        }


        try {

            String numero =
                    valor.trim();


            // Eliminar símbolo $
            numero =
                    numero.replace(
                            "$",
                            ""
                    );


            // Eliminar espacios
            numero =
                    numero.replace(
                            " ",
                            ""
                    );


            // Formato 35.000,50
            if (numero.contains(",")
                    && numero.contains(".")) {

                int ultimaComa =
                        numero.lastIndexOf(",");

                int ultimoPunto =
                        numero.lastIndexOf(".");


                if (ultimaComa > ultimoPunto) {

                    numero =
                            numero.replace(
                                    ".",
                                    ""
                            );

                    numero =
                            numero.replace(
                                    ",",
                                    "."
                            );

                } else {

                    numero =
                            numero.replace(
                                    ",",
                                    ""
                            );
                }


            } else if (numero.contains(",")) {

                numero =
                        numero.replace(
                                ",",
                                "."
                        );


            } else if (numero.matches(
                    "\\d+\\.\\d{3}"
            )) {

                // Ejemplo: 35.000
                numero =
                        numero.replace(
                                ".",
                                ""
                        );
            }


            return new BigDecimal(
                    numero
            );


        } catch (NumberFormatException e) {

            return BigDecimal.ZERO;
        }
    }
}
