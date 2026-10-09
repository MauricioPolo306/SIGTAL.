package com.mycompany.sigtal.controlador;

import com.mycompany.sigtal.dao.DashboardDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet encargado de cargar la información
 * principal del Dashboard de SIGTAL.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO =
            new DashboardDAO();


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        cargarDashboard(request, response);
    }


    /**
     * Obtiene toda la información necesaria
     * para mostrar el Dashboard.
     */
    private void cargarDashboard(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // ==================================================
            // INDICADORES PRINCIPALES
            // ==================================================

            int totalClientes =
                    dashboardDAO.obtenerTotalClientes();

            int totalVehiculos =
                    dashboardDAO.obtenerTotalVehiculos();

            int totalProductos =
                    dashboardDAO.obtenerTotalProductos();

            int totalFacturas =
                    dashboardDAO.obtenerTotalFacturas();

            double totalVentas =
                    dashboardDAO.obtenerTotalVentas();

            int productosStockBajo =
                    dashboardDAO.obtenerProductosStockBajo();


            // ==================================================
            // INFORMACIÓN ADICIONAL
            // ==================================================

            var ventasPorMes =
                    dashboardDAO.obtenerVentasPorMes();

            var ultimasFacturas =
                    dashboardDAO.obtenerUltimasFacturas();

            var detalleStockBajo =
                    dashboardDAO.obtenerDetalleStockBajo();


            // ==================================================
            // ENVIAR INDICADORES AL JSP
            // ==================================================

            request.setAttribute(
                    "totalClientes",
                    totalClientes
            );

            request.setAttribute(
                    "totalVehiculos",
                    totalVehiculos
            );

            request.setAttribute(
                    "totalProductos",
                    totalProductos
            );

            request.setAttribute(
                    "totalFacturas",
                    totalFacturas
            );

            request.setAttribute(
                    "totalVentas",
                    totalVentas
            );

            request.setAttribute(
                    "productosStockBajo",
                    productosStockBajo
            );


            // ==================================================
            // ENVIAR INFORMACIÓN ADICIONAL AL JSP
            // ==================================================

            request.setAttribute(
                    "ventasPorMes",
                    ventasPorMes
            );

            request.setAttribute(
                    "ultimasFacturas",
                    ultimasFacturas
            );

            request.setAttribute(
                    "detalleStockBajo",
                    detalleStockBajo
            );


            // ==================================================
            // CARGAR DASHBOARD
            // ==================================================

            request.getRequestDispatcher(
                    "/dashboard.jsp"
            ).forward(request, response);


        } catch (Exception e) {

            System.err.println(
                    "Error al cargar el Dashboard: "
                    + e.getMessage()
            );

            e.printStackTrace();


            request.setAttribute(
                    "errorDashboard",
                    "No fue posible cargar la información del Dashboard."
            );


            request.getRequestDispatcher(
                    "/dashboard.jsp"
            ).forward(request, response);
        }
    }
}
