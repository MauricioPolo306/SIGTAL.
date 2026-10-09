package com.mycompany.sigtal.controlador;

import com.mycompany.sigtal.dao.ReporteDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet("/reportes")
public class ReporteServlet extends HttpServlet {

    private final ReporteDAO reporteDAO =
            new ReporteDAO();


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        /* =====================================================
           FECHAS
           ===================================================== */

        LocalDate hoy = LocalDate.now();

        String fechaInicio =
                request.getParameter("fechaInicio");

        String fechaFin =
                request.getParameter("fechaFin");


        if (fechaInicio == null
                || fechaInicio.trim().isEmpty()) {

            fechaInicio =
                    hoy.withDayOfMonth(1).toString();
        }


        if (fechaFin == null
                || fechaFin.trim().isEmpty()) {

            fechaFin =
                    hoy.toString();
        }


        /* =====================================================
           CONSULTAS
           ===================================================== */

        Map<String, Object> resumen =
                reporteDAO.obtenerResumen();


        List<Map<String, Object>> ventas =
                reporteDAO.obtenerVentasPorFecha(
                        fechaInicio,
                        fechaFin
                );


        List<Map<String, Object>> clientes =
                reporteDAO.obtenerFacturacionPorCliente(
                        fechaInicio,
                        fechaFin
                );


        List<Map<String, Object>> facturas =
                reporteDAO.obtenerFacturas(
                        fechaInicio,
                        fechaFin
                );


        List<Map<String, Object>> inventario =
                reporteDAO.obtenerInventario();


        List<Map<String, Object>> stockBajo =
                reporteDAO.obtenerStockBajo();


        double valorInventario =
                reporteDAO.obtenerValorInventario();


        /* =====================================================
           ENVIAR DATOS A JSP
           ===================================================== */

        request.setAttribute(
                "resumen",
                resumen
        );


        request.setAttribute(
                "ventas",
                ventas
        );


        request.setAttribute(
                "clientesReporte",
                clientes
        );


        request.setAttribute(
                "facturasReporte",
                facturas
        );


        request.setAttribute(
                "inventarioReporte",
                inventario
        );


        request.setAttribute(
                "stockBajoReporte",
                stockBajo
        );


        request.setAttribute(
                "valorInventario",
                valorInventario
        );


        request.setAttribute(
                "fechaInicio",
                fechaInicio
        );


        request.setAttribute(
                "fechaFin",
                fechaFin
        );


        /* =====================================================
           ABRIR VISTA
           ===================================================== */

        request.getRequestDispatcher(
                "/reportes.jsp"
        ).forward(
                request,
                response
        );
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}
