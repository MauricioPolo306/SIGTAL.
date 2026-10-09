package com.mycompany.sigtal.dao;

import com.mycompany.sigtal.util.ConexionBD;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReporteDAO {

    /* =========================================================
       RESUMEN GENERAL
       ========================================================= */

    public Map<String, Object> obtenerResumen() {

        Map<String, Object> resumen = new HashMap<>();

        String sql = """
                SELECT
                    COUNT(*) AS total_facturas,
                    COALESCE(SUM(total), 0) AS total_ventas,
                    COALESCE(AVG(total), 0) AS promedio_factura
                FROM facturas
                WHERE estado <> 'ANULADA'
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                resumen.put(
                        "totalFacturas",
                        rs.getInt("total_facturas")
                );

                resumen.put(
                        "totalVentas",
                        rs.getDouble("total_ventas")
                );

                resumen.put(
                        "promedioFactura",
                        rs.getDouble("promedio_factura")
                );
            }

        } catch (Exception e) {

            System.err.println(
                    "Error obteniendo resumen: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return resumen;
    }


    /* =========================================================
       VENTAS POR FECHA
       ========================================================= */

    public List<Map<String, Object>> obtenerVentasPorFecha(
            String fechaInicio,
            String fechaFin) {

        List<Map<String, Object>> lista =
                new ArrayList<>();

        String sql = """
                SELECT
                    DATE(fecha_factura) AS fecha,
                    COUNT(*) AS cantidad_facturas,
                    COALESCE(SUM(total), 0) AS total_ventas
                FROM facturas
                WHERE estado <> 'ANULADA'
                  AND DATE(fecha_factura) BETWEEN ? AND ?
                GROUP BY DATE(fecha_factura)
                ORDER BY DATE(fecha_factura)
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, fechaInicio);
            ps.setString(2, fechaFin);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> fila =
                            new HashMap<>();

                    fila.put(
                            "fecha",
                            rs.getDate("fecha")
                    );

                    fila.put(
                            "cantidadFacturas",
                            rs.getInt("cantidad_facturas")
                    );

                    fila.put(
                            "totalVentas",
                            rs.getDouble("total_ventas")
                    );

                    lista.add(fila);
                }
            }

        } catch (Exception e) {

            System.err.println(
                    "Error obteniendo ventas por fecha: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return lista;
    }


    /* =========================================================
       FACTURAS POR CLIENTE
       ========================================================= */

    public List<Map<String, Object>> obtenerFacturacionPorCliente(
            String fechaInicio,
            String fechaFin) {

        List<Map<String, Object>> lista =
                new ArrayList<>();

        String sql = """
                SELECT
                    c.id_cliente,
                    c.nombre,
                    c.documento,
                    COUNT(f.id_factura) AS cantidad_facturas,
                    COALESCE(SUM(f.total), 0) AS total_facturado
                FROM clientes c
                INNER JOIN facturas f
                    ON c.id_cliente = f.id_cliente
                WHERE f.estado <> 'ANULADA'
                  AND DATE(f.fecha_factura) BETWEEN ? AND ?
                GROUP BY
                    c.id_cliente,
                    c.nombre,
                    c.documento
                ORDER BY total_facturado DESC
                LIMIT 10
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, fechaInicio);
            ps.setString(2, fechaFin);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> fila =
                            new HashMap<>();

                    fila.put(
                            "idCliente",
                            rs.getInt("id_cliente")
                    );

                    fila.put(
                            "nombre",
                            rs.getString("nombre")
                    );

                    fila.put(
                            "documento",
                            rs.getString("documento")
                    );

                    fila.put(
                            "cantidadFacturas",
                            rs.getInt("cantidad_facturas")
                    );

                    fila.put(
                            "totalFacturado",
                            rs.getDouble("total_facturado")
                    );

                    lista.add(fila);
                }
            }

        } catch (Exception e) {

            System.err.println(
                    "Error obteniendo clientes: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return lista;
    }


    /* =========================================================
       INVENTARIO GENERAL
       ========================================================= */

    public List<Map<String, Object>> obtenerInventario() {

        List<Map<String, Object>> lista =
                new ArrayList<>();

        String sql = """
                SELECT
                    id_producto,
                    codigo,
                    nombre,
                    categoria,
                    marca,
                    cantidad,
                    stock_minimo,
                    precio_compra,
                    precio_venta,
                    estado
                FROM inventario
                ORDER BY nombre
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> fila =
                        new HashMap<>();

                fila.put(
                        "idProducto",
                        rs.getInt("id_producto")
                );

                fila.put(
                        "codigo",
                        rs.getString("codigo")
                );

                fila.put(
                        "nombre",
                        rs.getString("nombre")
                );

                fila.put(
                        "categoria",
                        rs.getString("categoria")
                );

                fila.put(
                        "marca",
                        rs.getString("marca")
                );

                fila.put(
                        "cantidad",
                        rs.getInt("cantidad")
                );

                fila.put(
                        "stockMinimo",
                        rs.getInt("stock_minimo")
                );

                fila.put(
                        "precioCompra",
                        rs.getDouble("precio_compra")
                );

                fila.put(
                        "precioVenta",
                        rs.getDouble("precio_venta")
                );

                fila.put(
                        "estado",
                        rs.getString("estado")
                );

                lista.add(fila);
            }

        } catch (Exception e) {

            System.err.println(
                    "Error obteniendo inventario: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return lista;
    }


    /* =========================================================
       PRODUCTOS CON STOCK BAJO
       ========================================================= */

    public List<Map<String, Object>> obtenerStockBajo() {

        List<Map<String, Object>> lista =
                new ArrayList<>();

        String sql = """
                SELECT
                    id_producto,
                    codigo,
                    nombre,
                    categoria,
                    cantidad,
                    stock_minimo,
                    precio_venta
                FROM inventario
                WHERE cantidad <= stock_minimo
                  AND estado = 'ACTIVO'
                ORDER BY cantidad ASC
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> fila =
                        new HashMap<>();

                fila.put(
                        "idProducto",
                        rs.getInt("id_producto")
                );

                fila.put(
                        "codigo",
                        rs.getString("codigo")
                );

                fila.put(
                        "nombre",
                        rs.getString("nombre")
                );

                fila.put(
                        "categoria",
                        rs.getString("categoria")
                );

                fila.put(
                        "cantidad",
                        rs.getInt("cantidad")
                );

                fila.put(
                        "stockMinimo",
                        rs.getInt("stock_minimo")
                );

                fila.put(
                        "precioVenta",
                        rs.getDouble("precio_venta")
                );

                lista.add(fila);
            }

        } catch (Exception e) {

            System.err.println(
                    "Error obteniendo stock bajo: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return lista;
    }


    /* =========================================================
       FACTURAS RECIENTES
       ========================================================= */

    public List<Map<String, Object>> obtenerFacturas(
            String fechaInicio,
            String fechaFin) {

        List<Map<String, Object>> lista =
                new ArrayList<>();

        String sql = """
                SELECT
                    f.id_factura,
                    f.numero_factura,
                    f.fecha_factura,
                    c.nombre AS cliente,
                    c.documento,
                    f.subtotal,
                    f.descuento,
                    f.impuesto,
                    f.total,
                    f.estado
                FROM facturas f
                INNER JOIN clientes c
                    ON f.id_cliente = c.id_cliente
                WHERE DATE(f.fecha_factura)
                      BETWEEN ? AND ?
                ORDER BY f.fecha_factura DESC
                LIMIT 50
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, fechaInicio);
            ps.setString(2, fechaFin);

            try (ResultSet rs = ps.executeQuery()) {

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
                            "cliente",
                            rs.getString("cliente")
                    );

                    fila.put(
                            "documento",
                            rs.getString("documento")
                    );

                    fila.put(
                            "subtotal",
                            rs.getDouble("subtotal")
                    );

                    fila.put(
                            "descuento",
                            rs.getDouble("descuento")
                    );

                    fila.put(
                            "impuesto",
                            rs.getDouble("impuesto")
                    );

                    fila.put(
                            "total",
                            rs.getDouble("total")
                    );

                    fila.put(
                            "estado",
                            rs.getString("estado")
                    );

                    lista.add(fila);
                }
            }

        } catch (Exception e) {

            System.err.println(
                    "Error obteniendo facturas: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return lista;
    }


    /* =========================================================
       VALOR DEL INVENTARIO
       ========================================================= */

    public double obtenerValorInventario() {

        String sql = """
                SELECT
                    COALESCE(
                        SUM(cantidad * precio_compra),
                        0
                    ) AS valor
                FROM inventario
                WHERE estado = 'ACTIVO'
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                return rs.getDouble("valor");
            }

        } catch (Exception e) {

            System.err.println(
                    "Error obteniendo valor del inventario: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return 0;
    }
}
