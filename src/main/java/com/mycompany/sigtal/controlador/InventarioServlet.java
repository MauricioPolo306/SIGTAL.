package com.mycompany.sigtal.controlador;

import com.mycompany.sigtal.dao.InventarioDAO;
import com.mycompany.sigtal.modelo.Producto;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/inventario")
public class InventarioServlet extends HttpServlet {

    private final InventarioDAO inventarioDAO = new InventarioDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if (accion == null || accion.equals("listar")) {

            listarProductos(request, response);

        } else if (accion.equals("editar")) {

            mostrarFormularioEdicion(request, response);

        } else if (accion.equals("eliminar")) {

            eliminarProducto(request, response);

        } else {

            listarProductos(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {

            registrarProducto(request, response);

        } else if ("actualizar".equals(accion)) {

            actualizarProducto(request, response);

        } else {

            response.sendRedirect(
                    request.getContextPath() + "/inventario"
            );
        }
    }

    private void listarProductos(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Producto> productos =
                inventarioDAO.listar();

        request.setAttribute(
                "productos",
                productos
        );

        request.getRequestDispatcher(
                "/inventario.jsp"
        ).forward(request, response);
    }

    private void registrarProducto(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Producto producto =
                construirProductoDesdeRequest(request);

        boolean registrado =
                inventarioDAO.registrar(producto);

        if (registrado) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/inventario?mensaje=registrado"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/inventario?error=registro"
            );
        }
    }

    private void actualizarProducto(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            int idProducto = Integer.parseInt(
                    request.getParameter("idProducto")
            );

            Producto producto =
                    construirProductoDesdeRequest(request);

            producto.setIdProducto(idProducto);

            boolean actualizado =
                    inventarioDAO.actualizar(producto);

            if (actualizado) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/inventario?mensaje=actualizado"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/inventario?error=actualizacion"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/inventario?error=idInvalido"
            );
        }
    }

    private void mostrarFormularioEdicion(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String parametroId =
                request.getParameter("id");

        if (parametroId == null
                || parametroId.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/inventario"
            );

            return;
        }

        try {

            int idProducto =
                    Integer.parseInt(parametroId);

            Producto producto =
                    inventarioDAO.buscarPorId(idProducto);

            if (producto == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/inventario?error=noEncontrado"
                );

                return;
            }

            request.setAttribute(
                    "productoEditar",
                    producto
            );

            listarProductos(request, response);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/inventario?error=idInvalido"
            );
        }
    }

    private void eliminarProducto(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String parametroId =
                request.getParameter("id");

        if (parametroId == null
                || parametroId.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/inventario"
            );

            return;
        }

        try {

            int idProducto =
                    Integer.parseInt(parametroId);

            boolean eliminado =
                    inventarioDAO.eliminar(idProducto);

            if (eliminado) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/inventario?mensaje=eliminado"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/inventario?error=eliminacion"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/inventario?error=idInvalido"
            );
        }
    }

    private Producto construirProductoDesdeRequest(
            HttpServletRequest request) {

        String codigo =
                request.getParameter("codigo");

        String nombre =
                request.getParameter("nombre");

        String categoria =
                request.getParameter("categoria");

        String marca =
                request.getParameter("marca");

        String descripcion =
                request.getParameter("descripcion");

        int cantidad =
                convertirEntero(
                        request.getParameter("cantidad")
                );

        int stockMinimo =
                convertirEntero(
                        request.getParameter("stockMinimo")
                );

        double precioCompra =
                convertirDecimal(
                        request.getParameter("precioCompra")
                );

        double precioVenta =
                convertirDecimal(
                        request.getParameter("precioVenta")
                );

        String proveedor =
                request.getParameter("proveedor");

        String estado =
                request.getParameter("estado");

        if (estado == null || estado.isBlank()) {
            estado = "ACTIVO";
        }

        return new Producto(
                codigo,
                nombre,
                categoria,
                marca,
                descripcion,
                cantidad,
                stockMinimo,
                precioCompra,
                precioVenta,
                proveedor,
                estado
        );
    }

    private int convertirEntero(String valor) {

        try {

            return Integer.parseInt(valor);

        } catch (NumberFormatException e) {

            return 0;
        }
    }

    private double convertirDecimal(String valor) {

        try {

            return Double.parseDouble(valor);

        } catch (NumberFormatException e) {

            return 0.0;
        }
    }
}