package com.mycompany.sigtal.dao;

import com.mycompany.sigtal.util.ConexionBD;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO encargado de obtener la información
 * estadística del Dashboard de SIGTAL.
 */
public class DashboardDAO {

    // ==========================================================
    // TOTAL DE CLIENTES
    // ==========================================================

    public int obtenerTotalClientes() {

        String sql = "SELECT COUNT(*) FROM clientes";

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println(
                    "Error al obtener total de clientes: "
                    + e.getMessage()
            );
        }

        return 0;
    }


    // ==========================================================
    // TOTAL DE VEHÍCULOS
    // ==========================================================

    public int obtenerTotalVehiculos() {

        String sql = "SELECT COUNT(*) FROM vehiculos";

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println(
                    "Error al obtener total de vehículos: "
                    + e.getMessage()
            );
        }

        return 0;
    }


    // ==========================================================
    // TOTAL DE PRODUCTOS
    // ==========================================================

    public int obtenerTotalProductos() {

        String sql = "SELECT COUNT(*) FROM inventario";

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println(
                    "Error al obtener total de productos: "
                    + e.getMessage()
            );
        }

        return 0;
    }


    // ==========================================================
    // TOTAL DE FACTURAS
    // ==========================================================

    public int obtenerTotalFacturas() {

        String sql = "SELECT COUNT(*) FROM facturas";

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println(
                    "Error al obtener total de facturas: "
                    + e.getMessage()
            );
        }

        return 0;
    }


    // ==========================================================
    // TOTAL DE VENTAS
    // ==========================================================

    public double obtenerTotalVentas() {

        String sql = """
                SELECT COALESCE(SUM(total), 0)
                FROM facturas
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (SQLException e) {
            System.err.println(
                    "Error al obtener total de ventas: "
                    + e.getMessage()
            );
        }

        return 0;
    }


    // ==========================================================
    // PRODUCTOS CON STOCK BAJO
    // ==========================================================

    public int obtenerProductosStockBajo() {

        String sql = """
                SELECT COUNT(*)
                FROM inventario
                WHERE cantidad <= stock_minimo
                AND estado = 'ACTIVO'
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println(
                    "Error al obtener productos con stock bajo: "
                    + e.getMessage()
            );
        }

        return 0;
    }


    // ==========================================================
    // VENTAS POR MES
    // ==========================================================

    /**
     * Obtiene las ventas agrupadas por mes
     * de los últimos 6 meses.
     *
     * Retorna una lista de mapas con:
     *
     * mes   -> nombre del mes
     * total -> valor vendido
     */
    public List<Map<String, Object>> obtenerVentasPorMes() {

        List<Map<String, Object>> ventas =
                new ArrayList<>();

        String sql = """
                SELECT
                    DATE_FORMAT(fecha_factura, '%Y-%m') AS periodo,
                    DATE_FORMAT(fecha_factura, '%b %Y') AS mes,
                    COALESCE(SUM(total), 0) AS total
                FROM facturas
                WHERE fecha_factura >= DATE_SUB(
                    CURDATE(),
                    INTERVAL 5 MONTH
                )
                GROUP BY
                    YEAR(fecha_factura),
                    MONTH(fecha_factura)
                ORDER BY
                    YEAR(fecha_factura),
                    MONTH(fecha_factura)
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps =
                     conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> fila =
                        new HashMap<>();

                fila.put(
                        "periodo",
                        rs.getString("periodo")
                );

                fila.put(
                        "mes",
                        rs.getString("mes")
                );

                fila.put(
                        "total",
                        rs.getDouble("total")
                );

                ventas.add(fila);
            }

        } catch (SQLException e) {

            System.err.println(
                    "Error al obtener ventas por mes: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return ventas;
    }


    // ==========================================================
    // ÚLTIMAS FACTURAS
    // ==========================================================

    /**
     * Obtiene las últimas 5 facturas registradas.
     */
    public List<Map<String, Object>> obtenerUltimasFacturas() {

        List<Map<String, Object>> facturas =
                new ArrayList<>();

        String sql = """
                SELECT
                    f.id_factura,
                    f.numero_factura,
                    f.fecha_factura,
                    f.total,
                    f.estado,
                    c.nombre AS cliente
                FROM facturas f
                INNER JOIN clientes c
                    ON f.id_cliente = c.id_cliente
                ORDER BY
                    f.fecha_factura DESC
                LIMIT 5
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps =
                     conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> fila =
                        new HashMap<>();

                fila.put(
                        "idFactura",
                        rs.getInt("id_factura")
                );

                fila.put(
                        "numeroFactura",
                        rs.getString("numero_factura")
                );

                fila.put(
                        "fechaFactura",
                        rs.getTimestamp("fecha_factura")
                );

                fila.put(
                        "total",
                        rs.getDouble("total")
                );

                fila.put(
                        "estado",
                        rs.getString("estado")
                );

                fila.put(
                        "cliente",
                        rs.getString("cliente")
                );

                facturas.add(fila);
            }

        } catch (SQLException e) {

            System.err.println(
                    "Error al obtener últimas facturas: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return facturas;
    }


    // ==========================================================
    // PRODUCTOS CON STOCK BAJO
    // ==========================================================

    /**
     * Obtiene los productos que necesitan reposición.
     */
    public List<Map<String, Object>> obtenerDetalleStockBajo() {

        List<Map<String, Object>> productos =
                new ArrayList<>();

        String sql = """
                SELECT
                    id_producto,
                    codigo,
                    nombre,
                    categoria,
                    cantidad,
                    stock_minimo
                FROM inventario
                WHERE cantidad <= stock_minimo
                AND estado = 'ACTIVO'
                ORDER BY cantidad ASC
                LIMIT 5
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps =
                     conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> producto =
                        new HashMap<>();

                producto.put(
                        "idProducto",
                        rs.getInt("id_producto")
                );

                producto.put(
                        "codigo",
                        rs.getString("codigo")
                );

                producto.put(
                        "nombre",
                        rs.getString("nombre")
                );

                producto.put(
                        "categoria",
                        rs.getString("categoria")
                );

                producto.put(
                        "cantidad",
                        rs.getInt("cantidad")
                );

                producto.put(
                        "stockMinimo",
                        rs.getInt("stock_minimo")
                );

                productos.add(producto);
            }

        } catch (SQLException e) {

            System.err.println(
                    "Error al obtener stock bajo: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return productos;
    }
}