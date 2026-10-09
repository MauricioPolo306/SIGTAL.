package com.mycompany.sigtal.dao;

import com.mycompany.sigtal.modelo.Producto;
import com.mycompany.sigtal.util.ConexionBD;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InventarioDAO {

    // Registrar producto
    public boolean registrar(Producto producto) {

        String sql = "INSERT INTO inventario "
                + "(codigo, nombre, categoria, marca, descripcion, "
                + "cantidad, stock_minimo, precio_compra, precio_venta, "
                + "proveedor, estado) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement sentencia = conexion.prepareStatement(sql)) {

            sentencia.setString(1, producto.getCodigo());
            sentencia.setString(2, producto.getNombre());
            sentencia.setString(3, producto.getCategoria());
            sentencia.setString(4, producto.getMarca());
            sentencia.setString(5, producto.getDescripcion());
            sentencia.setInt(6, producto.getCantidad());
            sentencia.setInt(7, producto.getStockMinimo());
            sentencia.setDouble(8, producto.getPrecioCompra());
            sentencia.setDouble(9, producto.getPrecioVenta());
            sentencia.setString(10, producto.getProveedor());
            sentencia.setString(11, producto.getEstado());

            return sentencia.executeUpdate() > 0;

        } catch (SQLException e) {

            System.err.println(
                    "Error al registrar producto: "
                    + e.getMessage()
            );

            return false;
        }
    }

    // Listar productos
    public List<Producto> listar() {

        List<Producto> productos = new ArrayList<>();

        String sql = "SELECT * FROM inventario "
                + "ORDER BY id_producto DESC";

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement sentencia = conexion.prepareStatement(sql);
             ResultSet resultado = sentencia.executeQuery()) {

            while (resultado.next()) {

                productos.add(mapearProducto(resultado));
            }

        } catch (SQLException e) {

            System.err.println(
                    "Error al listar inventario: "
                    + e.getMessage()
            );
        }

        return productos;
    }

    // Buscar producto por ID
    public Producto buscarPorId(int idProducto) {

        String sql = "SELECT * FROM inventario "
                + "WHERE id_producto = ?";

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement sentencia = conexion.prepareStatement(sql)) {

            sentencia.setInt(1, idProducto);

            try (ResultSet resultado = sentencia.executeQuery()) {

                if (resultado.next()) {

                    return mapearProducto(resultado);
                }
            }

        } catch (SQLException e) {

            System.err.println(
                    "Error al buscar producto: "
                    + e.getMessage()
            );
        }

        return null;
    }

    // Actualizar producto
    public boolean actualizar(Producto producto) {

        String sql = "UPDATE inventario SET "
                + "codigo = ?, "
                + "nombre = ?, "
                + "categoria = ?, "
                + "marca = ?, "
                + "descripcion = ?, "
                + "cantidad = ?, "
                + "stock_minimo = ?, "
                + "precio_compra = ?, "
                + "precio_venta = ?, "
                + "proveedor = ?, "
                + "estado = ? "
                + "WHERE id_producto = ?";

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement sentencia = conexion.prepareStatement(sql)) {

            sentencia.setString(1, producto.getCodigo());
            sentencia.setString(2, producto.getNombre());
            sentencia.setString(3, producto.getCategoria());
            sentencia.setString(4, producto.getMarca());
            sentencia.setString(5, producto.getDescripcion());
            sentencia.setInt(6, producto.getCantidad());
            sentencia.setInt(7, producto.getStockMinimo());
            sentencia.setDouble(8, producto.getPrecioCompra());
            sentencia.setDouble(9, producto.getPrecioVenta());
            sentencia.setString(10, producto.getProveedor());
            sentencia.setString(11, producto.getEstado());
            sentencia.setInt(12, producto.getIdProducto());

            return sentencia.executeUpdate() > 0;

        } catch (SQLException e) {

            System.err.println(
                    "Error al actualizar producto: "
                    + e.getMessage()
            );

            return false;
        }
    }

    // Eliminar producto
    public boolean eliminar(int idProducto) {

        String sql = "DELETE FROM inventario "
                + "WHERE id_producto = ?";

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement sentencia = conexion.prepareStatement(sql)) {

            sentencia.setInt(1, idProducto);

            return sentencia.executeUpdate() > 0;

        } catch (SQLException e) {

            System.err.println(
                    "Error al eliminar producto: "
                    + e.getMessage()
            );

            return false;
        }
    }

    // Convertir ResultSet en objeto Producto
    private Producto mapearProducto(ResultSet resultado)
            throws SQLException {

        Producto producto = new Producto();

        producto.setIdProducto(
                resultado.getInt("id_producto")
        );

        producto.setCodigo(
                resultado.getString("codigo")
        );

        producto.setNombre(
                resultado.getString("nombre")
        );

        producto.setCategoria(
                resultado.getString("categoria")
        );

        producto.setMarca(
                resultado.getString("marca")
        );

        producto.setDescripcion(
                resultado.getString("descripcion")
        );

        producto.setCantidad(
                resultado.getInt("cantidad")
        );

        producto.setStockMinimo(
                resultado.getInt("stock_minimo")
        );

        producto.setPrecioCompra(
                resultado.getDouble("precio_compra")
        );

        producto.setPrecioVenta(
                resultado.getDouble("precio_venta")
        );

        producto.setProveedor(
                resultado.getString("proveedor")
        );

        producto.setEstado(
                resultado.getString("estado")
        );

        return producto;
    }
}