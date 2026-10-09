package com.mycompany.sigtal.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {

    private static final String URL =
            "jdbc:mariadb://localhost:3306/sigtal?useUnicode=true&characterEncoding=UTF-8";

    private static final String USUARIO = "root";
    private static final String CONTRASENA = "";

    public static Connection obtenerConexion() throws SQLException {

        try {
            Class.forName("org.mariadb.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "No se encontró el driver JDBC de MariaDB.", e
            );
        }

        return DriverManager.getConnection(
                URL,
                USUARIO,
                CONTRASENA
        );
    }

    public static void cerrarConexion(Connection conexion) {

        if (conexion != null) {

            try {
                conexion.close();

            } catch (SQLException e) {

                System.err.println(
                        "Error al cerrar la conexión: "
                        + e.getMessage()
                );
            }
        }
    }
}