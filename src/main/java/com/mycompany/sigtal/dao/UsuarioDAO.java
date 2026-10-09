package com.mycompany.sigtal.dao;

import com.mycompany.sigtal.modelo.Usuario;
import com.mycompany.sigtal.util.ConexionBD;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    /* =========================================================
       AUTENTICAR USUARIO
       ========================================================= */

    public Usuario autenticar(String usuarioNombre, String password) {

        String sql = """
                SELECT id_usuario,
                       nombre,
                       usuario,
                       password,
                       rol,
                       estado
                FROM usuarios
                WHERE usuario = ?
                  AND password = ?
                  AND estado = 'ACTIVO'
                LIMIT 1
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, usuarioNombre);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Usuario usuario = new Usuario();

                    usuario.setIdUsuario(
                            rs.getInt("id_usuario")
                    );

                    usuario.setNombre(
                            rs.getString("nombre")
                    );

                    usuario.setUsuario(
                            rs.getString("usuario")
                    );

                    usuario.setPassword(
                            rs.getString("password")
                    );

                    usuario.setRol(
                            rs.getString("rol")
                    );

                    usuario.setEstado(
                            rs.getString("estado")
                    );

                    return usuario;
                }
            }

        } catch (Exception e) {

            System.err.println(
                    "Error al autenticar usuario: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return null;
    }


    /* =========================================================
       LISTAR TODOS LOS USUARIOS
       ========================================================= */

    public List<Usuario> listarUsuarios() {

        List<Usuario> lista = new ArrayList<>();

        String sql = """
                SELECT id_usuario,
                       nombre,
                       usuario,
                       password,
                       rol,
                       estado
                FROM usuarios
                ORDER BY id_usuario DESC
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Usuario usuario = new Usuario();

                usuario.setIdUsuario(
                        rs.getInt("id_usuario")
                );

                usuario.setNombre(
                        rs.getString("nombre")
                );

                usuario.setUsuario(
                        rs.getString("usuario")
                );

                /*
                 * No necesitamos mostrar la contraseña
                 * en la interfaz, pero la conservamos
                 * para mantener compatible el modelo.
                 */
                usuario.setPassword(
                        rs.getString("password")
                );

                usuario.setRol(
                        rs.getString("rol")
                );

                usuario.setEstado(
                        rs.getString("estado")
                );

                lista.add(usuario);
            }

        } catch (Exception e) {

            System.err.println(
                    "Error al listar usuarios: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return lista;
    }


    /* =========================================================
       BUSCAR USUARIO POR ID
       ========================================================= */

    public Usuario buscarUsuario(int idUsuario) {

        String sql = """
                SELECT id_usuario,
                       nombre,
                       usuario,
                       password,
                       rol,
                       estado
                FROM usuarios
                WHERE id_usuario = ?
                LIMIT 1
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Usuario usuario = new Usuario();

                    usuario.setIdUsuario(
                            rs.getInt("id_usuario")
                    );

                    usuario.setNombre(
                            rs.getString("nombre")
                    );

                    usuario.setUsuario(
                            rs.getString("usuario")
                    );

                    usuario.setPassword(
                            rs.getString("password")
                    );

                    usuario.setRol(
                            rs.getString("rol")
                    );

                    usuario.setEstado(
                            rs.getString("estado")
                    );

                    return usuario;
                }
            }

        } catch (Exception e) {

            System.err.println(
                    "Error al buscar usuario: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return null;
    }


    /* =========================================================
       CREAR USUARIO
       ========================================================= */

    public boolean crearUsuario(
            String nombre,
            String usuario,
            String password,
            String rol,
            String estado) {

        String sql = """
                INSERT INTO usuarios
                (
                    nombre,
                    usuario,
                    password,
                    rol,
                    estado
                )
                VALUES (?, ?, ?, ?, ?)
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, nombre);
            ps.setString(2, usuario);
            ps.setString(3, password);
            ps.setString(4, rol);
            ps.setString(5, estado);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            System.err.println(
                    "Error al crear usuario: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return false;
    }


    /* =========================================================
       ACTUALIZAR USUARIO
       ========================================================= */

    public boolean actualizarUsuario(
            int idUsuario,
            String nombre,
            String usuario,
            String rol,
            String estado) {

        String sql = """
                UPDATE usuarios
                SET nombre = ?,
                    usuario = ?,
                    rol = ?,
                    estado = ?
                WHERE id_usuario = ?
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, nombre);
            ps.setString(2, usuario);
            ps.setString(3, rol);
            ps.setString(4, estado);
            ps.setInt(5, idUsuario);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            System.err.println(
                    "Error al actualizar usuario: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return false;
    }


    /* =========================================================
       CAMBIAR ESTADO
       ========================================================= */

    public boolean cambiarEstado(
            int idUsuario,
            String estado) {

        String sql = """
                UPDATE usuarios
                SET estado = ?
                WHERE id_usuario = ?
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, estado);
            ps.setInt(2, idUsuario);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            System.err.println(
                    "Error al cambiar estado: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return false;
    }


    /* =========================================================
       CAMBIAR CONTRASEÑA
       ========================================================= */

    public boolean cambiarPassword(
            int idUsuario,
            String password) {

        String sql = """
                UPDATE usuarios
                SET password = ?
                WHERE id_usuario = ?
                """;

        try (Connection conexion = ConexionBD.obtenerConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, password);
            ps.setInt(2, idUsuario);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            System.err.println(
                    "Error al cambiar contraseña: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return false;
    }
}
