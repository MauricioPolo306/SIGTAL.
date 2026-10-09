package com.mycompany.sigtal.dao;

import com.mycompany.sigtal.modelo.DetalleFactura;
import com.mycompany.sigtal.util.ConexionBD;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DetalleFacturaDAO {

    /**
     * Registra un detalle de factura.
     */
    public boolean registrar(DetalleFactura detalle) throws SQLException {

        String sql = """
                INSERT INTO detalle_factura (
                    id_factura,
                    id_producto,
                    descripcion,
                    cantidad,
                    precio_unitario,
                    descuento,
                    subtotal
                )
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, detalle.getIdFactura());

            if (detalle.getIdProducto() != null) {
                ps.setInt(2, detalle.getIdProducto());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setString(3, detalle.getDescripcion());
            ps.setInt(4, detalle.getCantidad());
            ps.setBigDecimal(5, detalle.getPrecioUnitario());
            ps.setBigDecimal(6, detalle.getDescuento());
            ps.setBigDecimal(7, detalle.getSubtotal());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lista los detalles de una factura.
     */
    public List<DetalleFactura> listarPorFactura(int idFactura)
            throws SQLException {

        List<DetalleFactura> detalles = new ArrayList<>();

        String sql = """
                SELECT
                    id_detalle,
                    id_factura,
                    id_producto,
                    descripcion,
                    cantidad,
                    precio_unitario,
                    descuento,
                    subtotal
                FROM detalle_factura
                WHERE id_factura = ?
                ORDER BY id_detalle ASC
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, idFactura);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    detalles.add(mapearDetalle(rs));
                }
            }
        }

        return detalles;
    }

    /**
     * Busca un detalle por su ID.
     */
    public DetalleFactura buscarPorId(int idDetalle)
            throws SQLException {

        String sql = """
                SELECT
                    id_detalle,
                    id_factura,
                    id_producto,
                    descripcion,
                    cantidad,
                    precio_unitario,
                    descuento,
                    subtotal
                FROM detalle_factura
                WHERE id_detalle = ?
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, idDetalle);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapearDetalle(rs);
                }
            }
        }

        return null;
    }

    /**
     * Actualiza un detalle existente.
     */
    public boolean actualizar(DetalleFactura detalle)
            throws SQLException {

        String sql = """
                UPDATE detalle_factura
                SET
                    id_producto = ?,
                    descripcion = ?,
                    cantidad = ?,
                    precio_unitario = ?,
                    descuento = ?,
                    subtotal = ?
                WHERE id_detalle = ?
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            if (detalle.getIdProducto() != null) {
                ps.setInt(1, detalle.getIdProducto());
            } else {
                ps.setNull(1, Types.INTEGER);
            }

            ps.setString(2, detalle.getDescripcion());
            ps.setInt(3, detalle.getCantidad());
            ps.setBigDecimal(4, detalle.getPrecioUnitario());
            ps.setBigDecimal(5, detalle.getDescuento());
            ps.setBigDecimal(6, detalle.getSubtotal());
            ps.setInt(7, detalle.getIdDetalle());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Elimina un detalle.
     */
    public boolean eliminar(int idDetalle)
            throws SQLException {

        String sql = """
                DELETE FROM detalle_factura
                WHERE id_detalle = ?
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, idDetalle);

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Elimina todos los detalles de una factura.
     */
    public boolean eliminarPorFactura(int idFactura)
            throws SQLException {

        String sql = """
                DELETE FROM detalle_factura
                WHERE id_factura = ?
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, idFactura);

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Convierte un ResultSet en un objeto DetalleFactura.
     */
    private DetalleFactura mapearDetalle(ResultSet rs)
            throws SQLException {

        Integer idProducto = null;

        int valorProducto = rs.getInt("id_producto");

        if (!rs.wasNull()) {
            idProducto = valorProducto;
        }

        return new DetalleFactura(
                rs.getInt("id_detalle"),
                rs.getInt("id_factura"),
                idProducto,
                rs.getString("descripcion"),
                rs.getInt("cantidad"),
                rs.getBigDecimal("precio_unitario"),
                rs.getBigDecimal("descuento"),
                rs.getBigDecimal("subtotal")
        );
    }
}