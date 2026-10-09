package com.mycompany.sigtal.dao;

import com.mycompany.sigtal.modelo.Cliente;
import com.mycompany.sigtal.util.ConexionBD;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {
   
    public boolean registrar(Cliente cliente) {

        String sql = """
                INSERT INTO clientes
                (nombre, documento, telefono, correo, direccion)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement sentencia = conexion.prepareStatement(sql)) {

            sentencia.setString(1, cliente.getNombre());
            sentencia.setString(2, cliente.getDocumento());
            sentencia.setString(3, cliente.getTelefono());
            sentencia.setString(4, cliente.getCorreo());
            sentencia.setString(5, cliente.getDireccion());

            return sentencia.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al registrar cliente: " + e.getMessage());
            return false;
        }
    }

    public List<Cliente> listar() {

        List<Cliente> clientes = new ArrayList<>();

        String sql = """
                SELECT id_cliente, nombre, documento,
                       telefono, correo, direccion
                FROM clientes
                ORDER BY id_cliente DESC
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement sentencia = conexion.prepareStatement(sql);
             ResultSet resultado = sentencia.executeQuery()) {

            while (resultado.next()) {

                Cliente cliente = new Cliente();

                cliente.setIdCliente(resultado.getInt("id_cliente"));
                cliente.setNombre(resultado.getString("nombre"));
                cliente.setDocumento(resultado.getString("documento"));
                cliente.setTelefono(resultado.getString("telefono"));
                cliente.setCorreo(resultado.getString("correo"));
                cliente.setDireccion(resultado.getString("direccion"));

                clientes.add(cliente);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar clientes: " + e.getMessage());
        }

        return clientes;
    }

    public Cliente buscarPorId(int idCliente) {

        String sql = """
                SELECT id_cliente, nombre, documento,
                       telefono, correo, direccion
                FROM clientes
                WHERE id_cliente = ?
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement sentencia = conexion.prepareStatement(sql)) {

            sentencia.setInt(1, idCliente);

            try (ResultSet resultado = sentencia.executeQuery()) {

                if (resultado.next()) {

                    Cliente cliente = new Cliente();

                    cliente.setIdCliente(resultado.getInt("id_cliente"));
                    cliente.setNombre(resultado.getString("nombre"));
                    cliente.setDocumento(resultado.getString("documento"));
                    cliente.setTelefono(resultado.getString("telefono"));
                    cliente.setCorreo(resultado.getString("correo"));
                    cliente.setDireccion(resultado.getString("direccion"));

                    return cliente;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar cliente: " + e.getMessage());
        }

        return null;
    }

    public boolean actualizar(Cliente cliente) {

        String sql = """
                UPDATE clientes
                SET nombre = ?,
                    documento = ?,
                    telefono = ?,
                    correo = ?,
                    direccion = ?
                WHERE id_cliente = ?
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement sentencia = conexion.prepareStatement(sql)) {

            sentencia.setString(1, cliente.getNombre());
            sentencia.setString(2, cliente.getDocumento());
            sentencia.setString(3, cliente.getTelefono());
            sentencia.setString(4, cliente.getCorreo());
            sentencia.setString(5, cliente.getDireccion());
            sentencia.setInt(6, cliente.getIdCliente());

            return sentencia.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar cliente: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int idCliente) {

        String sql = """
                DELETE FROM clientes
                WHERE id_cliente = ?
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement sentencia = conexion.prepareStatement(sql)) {

            sentencia.setInt(1, idCliente);

            return sentencia.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar cliente: " + e.getMessage());
            return false;
        }
    }
}