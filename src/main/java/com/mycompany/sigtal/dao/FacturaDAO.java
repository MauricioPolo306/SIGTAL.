package com.mycompany.sigtal.dao;

import com.mycompany.sigtal.modelo.DetalleFactura;
import com.mycompany.sigtal.modelo.Factura;
import com.mycompany.sigtal.util.ConexionBD;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FacturaDAO {

    /*
     * ============================================================
     * REGISTRAR FACTURA, DETALLES Y DESCUENTO DE INVENTARIO
     * Transaccional + Batching
     * ============================================================
     */
    public int registrar(Factura factura, List<DetalleFactura> detalles) {

        String sqlInsertFactura =
                "INSERT INTO facturas " +
                "(numero_factura, id_cliente, id_vehiculo, fecha_factura, " +
                "subtotal, descuento, impuesto, total, estado) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String sqlUpdateNumero =
                "UPDATE facturas " +
                "SET numero_factura = ? " +
                "WHERE id_factura = ?";

        /*
         * CORRECCIÓN:
         * Se agrega el campo tipo.
         *
         * PRODUCTO = detalle proveniente del inventario.
         * SERVICIO = servicio realizado por el taller.
         */
        String sqlInsertDetalle =
                "INSERT INTO detalle_factura " +
                "(id_factura, id_producto, tipo, descripcion, cantidad, " +
                "precio_unitario, descuento, subtotal) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        /*
         * IMPORTANTE:
         * La tabla inventario NO tiene una columna llamada stock.
         * La columna correcta es cantidad.
         */
        String sqlUpdateCantidad =
                "UPDATE inventario " +
                "SET cantidad = cantidad - ? " +
                "WHERE id_producto = ? " +
                "AND cantidad >= ?";

        Connection conexion = null;
        PreparedStatement psFactura = null;
        PreparedStatement psUpdateNumero = null;
        PreparedStatement psDetalle = null;
        PreparedStatement psCantidad = null;
        ResultSet claves = null;

        try {

            conexion = ConexionBD.obtenerConexion();
            conexion.setAutoCommit(false);

            // =====================================================
            // 1. INSERTAR ENCABEZADO DE FACTURA
            // =====================================================

            psFactura = conexion.prepareStatement(
                    sqlInsertFactura,
                    Statement.RETURN_GENERATED_KEYS
            );

            // Número temporal
            psFactura.setString(1, "TEMP");

            // Cliente
            psFactura.setInt(
                    2,
                    factura.getIdCliente()
            );

            // Vehículo
            if (factura.getIdVehiculo() == null ||
                factura.getIdVehiculo() == 0) {

                psFactura.setNull(
                        3,
                        java.sql.Types.INTEGER
                );

            } else {

                psFactura.setInt(
                        3,
                        factura.getIdVehiculo()
                );
            }

            // Fecha
            psFactura.setTimestamp(
                    4,
                    Timestamp.valueOf(
                            factura.getFechaFactura()
                    )
            );

            // Valores monetarios
            psFactura.setBigDecimal(
                    5,
                    valorSeguro(
                            factura.getSubtotal()
                    )
            );

            psFactura.setBigDecimal(
                    6,
                    valorSeguro(
                            factura.getDescuento()
                    )
            );

            psFactura.setBigDecimal(
                    7,
                    valorSeguro(
                            factura.getImpuesto()
                    )
            );

            psFactura.setBigDecimal(
                    8,
                    valorSeguro(
                            factura.getTotal()
                    )
            );

            // Estado
            psFactura.setString(
                    9,
                    factura.getEstado()
            );

            int filasAfectadas =
                    psFactura.executeUpdate();

            if (filasAfectadas == 0) {

                conexion.rollback();
                return 0;
            }

            // =====================================================
            // 2. OBTENER ID GENERADO
            // =====================================================

            claves = psFactura.getGeneratedKeys();

            if (!claves.next()) {

                conexion.rollback();
                return 0;
            }

            int idFactura =
                    claves.getInt(1);

            // Generar número de factura
            String numeroFactura =
                    String.format(
                            "FAC-%06d",
                            idFactura
                    );

            // =====================================================
            // 3. ACTUALIZAR NÚMERO DE FACTURA
            // =====================================================

            psUpdateNumero =
                    conexion.prepareStatement(
                            sqlUpdateNumero
                    );

            psUpdateNumero.setString(
                    1,
                    numeroFactura
            );

            psUpdateNumero.setInt(
                    2,
                    idFactura
            );

            psUpdateNumero.executeUpdate();

            // =====================================================
            // 4. INSERTAR DETALLES
            // =====================================================

            if (detalles != null &&
                !detalles.isEmpty()) {

                psDetalle =
                        conexion.prepareStatement(
                                sqlInsertDetalle
                        );

                psCantidad =
                        conexion.prepareStatement(
                                sqlUpdateCantidad
                        );

                for (DetalleFactura detalle : detalles) {

                    // =================================================
                    // ID FACTURA
                    // =================================================

                    psDetalle.setInt(
                            1,
                            idFactura
                    );

                    // =================================================
                    // PRODUCTO
                    // =================================================

                    if (detalle.getIdProducto() == null ||
                        detalle.getIdProducto() == 0) {

                        /*
                         * NULL = servicio.
                         * Los servicios no descuentan inventario.
                         */
                        psDetalle.setNull(
                                2,
                                java.sql.Types.INTEGER
                        );

                    } else {

                        psDetalle.setInt(
                                2,
                                detalle.getIdProducto()
                        );

                        // =================================================
                        // DESCONTAR CANTIDAD DEL INVENTARIO
                        // =================================================

                        psCantidad.setInt(
                                1,
                                detalle.getCantidad()
                        );

                        psCantidad.setInt(
                                2,
                                detalle.getIdProducto()
                        );

                        psCantidad.setInt(
                                3,
                                detalle.getCantidad()
                        );

                        psCantidad.addBatch();
                    }

                    // =================================================
                    // TIPO
                    // =================================================

                    if (detalle.getIdProducto() == null ||
                        detalle.getIdProducto() == 0) {

                        /*
                         * No existe producto asociado.
                         * Por lo tanto, es un servicio.
                         */
                        psDetalle.setString(
                                3,
                                "SERVICIO"
                        );

                    } else {

                        /*
                         * Existe producto asociado al inventario.
                         */
                        psDetalle.setString(
                                3,
                                "PRODUCTO"
                        );
                    }

                    // =================================================
                    // DESCRIPCIÓN
                    // =================================================

                    psDetalle.setString(
                            4,
                            detalle.getDescripcion()
                    );

                    // =================================================
                    // CANTIDAD
                    // =================================================

                    psDetalle.setInt(
                            5,
                            detalle.getCantidad()
                    );

                    // =================================================
                    // PRECIO UNITARIO
                    // =================================================

                    psDetalle.setBigDecimal(
                            6,
                            valorSeguro(
                                    detalle.getPrecioUnitario()
                            )
                    );

                    // =================================================
                    // DESCUENTO
                    // =================================================

                    psDetalle.setBigDecimal(
                            7,
                            valorSeguro(
                                    detalle.getDescuento()
                            )
                    );

                    // =================================================
                    // SUBTOTAL
                    // =================================================

                    psDetalle.setBigDecimal(
                            8,
                            valorSeguro(
                                    detalle.getSubtotal()
                            )
                    );

                    psDetalle.addBatch();
                }

                // =====================================================
                // INSERTAR TODOS LOS DETALLES
                // =====================================================

                psDetalle.executeBatch();

                // =====================================================
                // ACTUALIZAR INVENTARIO
                // =====================================================

                int[] resultadosCantidad =
                        psCantidad.executeBatch();

                /*
                 * Verificar que cada producto pudo descontarse.
                 */
                for (int filasActualizadas :
                        resultadosCantidad) {

                    if (filasActualizadas == 0) {

                        conexion.rollback();

                        System.err.println(
                                "Error: Uno de los productos " +
                                "no cuenta con suficiente cantidad " +
                                "disponible en inventario."
                        );

                        return 0;
                    }
                }
            }

            // =====================================================
            // 5. CONFIRMAR TRANSACCIÓN
            // =====================================================

            conexion.commit();

            factura.setIdFactura(
                    idFactura
            );

            factura.setNumeroFactura(
                    numeroFactura
            );

            System.out.println(
                    "Factura registrada correctamente: "
                    + numeroFactura
            );

            return idFactura;

        } catch (SQLException e) {

            if (conexion != null) {

                try {

                    conexion.rollback();

                } catch (SQLException ex) {

                    System.err.println(
                            "Error ejecutando rollback: "
                            + ex.getMessage()
                    );
                }
            }

            System.err.println(
                    "Error al registrar factura: "
                    + e.getMessage()
            );

            return 0;

        } finally {

            cerrarRecursos(
                    claves,
                    psFactura,
                    null
            );

            cerrarRecursos(
                    null,
                    psUpdateNumero,
                    null
            );

            cerrarRecursos(
                    null,
                    psDetalle,
                    null
            );

            cerrarRecursos(
                    null,
                    psCantidad,
                    conexion
            );
        }
    }


    /*
     * ============================================================
     * ACTUALIZAR FACTURA
     * ============================================================
     */
    public boolean actualizar(Factura factura) {

        String sql =
                "UPDATE facturas SET " +
                "id_cliente = ?, " +
                "id_vehiculo = ?, " +
                "fecha_factura = ?, " +
                "subtotal = ?, " +
                "descuento = ?, " +
                "impuesto = ?, " +
                "total = ?, " +
                "estado = ? " +
                "WHERE id_factura = ?";

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(sql)
        ) {

            // Cliente
            sentencia.setInt(
                    1,
                    factura.getIdCliente()
            );

            // Vehículo
            if (factura.getIdVehiculo() == null ||
                factura.getIdVehiculo() == 0) {

                sentencia.setNull(
                        2,
                        java.sql.Types.INTEGER
                );

            } else {

                sentencia.setInt(
                        2,
                        factura.getIdVehiculo()
                );
            }

            // Fecha
            sentencia.setTimestamp(
                    3,
                    Timestamp.valueOf(
                            factura.getFechaFactura()
                    )
            );

            // Valores
            sentencia.setBigDecimal(
                    4,
                    valorSeguro(
                            factura.getSubtotal()
                    )
            );

            sentencia.setBigDecimal(
                    5,
                    valorSeguro(
                            factura.getDescuento()
                    )
            );

            sentencia.setBigDecimal(
                    6,
                    valorSeguro(
                            factura.getImpuesto()
                    )
            );

            sentencia.setBigDecimal(
                    7,
                    valorSeguro(
                            factura.getTotal()
                    )
            );

            // Estado
            sentencia.setString(
                    8,
                    factura.getEstado()
            );

            // ID
            sentencia.setInt(
                    9,
                    factura.getIdFactura()
            );

            return sentencia.executeUpdate() > 0;

        } catch (SQLException e) {

            System.err.println(
                    "Error al actualizar factura: "
                    + e.getMessage()
            );

            return false;
        }
    }


    /*
     * ============================================================
     * BUSCAR FACTURA POR ID
     * ============================================================
     */
    public Factura buscarPorId(int idFactura) {

        String sql =
                "SELECT id_factura, numero_factura, " +
                "id_cliente, id_vehiculo, fecha_factura, " +
                "subtotal, descuento, impuesto, total, estado " +
                "FROM facturas " +
                "WHERE id_factura = ?";

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(sql)
        ) {

            sentencia.setInt(
                    1,
                    idFactura
            );

            try (
                    ResultSet resultado =
                            sentencia.executeQuery()
            ) {

                if (resultado.next()) {

                    return mapearFactura(
                            resultado
                    );
                }
            }

        } catch (SQLException e) {

            System.err.println(
                    "Error al buscar factura por ID: "
                    + e.getMessage()
            );
        }

        return null;
    }


    /*
     * ============================================================
     * BUSCAR FACTURAS
     * ============================================================
     */
    public List<Map<String, Object>> buscarFacturas(
            String texto,
            String estado,
            String fechaDesde,
            String fechaHasta) {

        List<Map<String, Object>> facturas =
                new ArrayList<>();

        StringBuilder sql =
                new StringBuilder();

        sql.append(
                "SELECT f.id_factura, " +
                "f.numero_factura, " +
                "f.fecha_factura, " +
                "f.subtotal, " +
                "f.descuento, " +
                "f.impuesto, " +
                "f.total, " +
                "f.estado, " +
                "f.id_cliente, " +
                "f.id_vehiculo, " +
                "c.nombre AS nombre_cliente, " +
                "c.documento AS documento_cliente, " +
                "c.telefono AS telefono_cliente, " +
                "v.placa AS placa_vehiculo, " +
                "v.marca AS marca_vehiculo, " +
                "v.modelo AS modelo_vehiculo " +
                "FROM facturas f " +
                "INNER JOIN clientes c " +
                "ON f.id_cliente = c.id_cliente " +
                "LEFT JOIN vehiculos v " +
                "ON f.id_vehiculo = v.id_vehiculo " +
                "WHERE 1 = 1 "
        );

        List<Object> parametros =
                new ArrayList<>();

        // =====================================================
        // BÚSQUEDA POR TEXTO
        // =====================================================

        if (texto != null &&
            !texto.isBlank()) {

            sql.append(
                    "AND (" +
                    "f.numero_factura LIKE ? " +
                    "OR c.nombre LIKE ? " +
                    "OR c.documento LIKE ?" +
                    ") "
            );

            String busqueda =
                    "%" + texto.trim() + "%";

            parametros.add(busqueda);
            parametros.add(busqueda);
            parametros.add(busqueda);
        }

        // =====================================================
        // FILTRO POR ESTADO
        // =====================================================

        if (estado != null &&
            !estado.isBlank() &&
            !"TODOS".equalsIgnoreCase(estado)) {

            sql.append(
                    "AND f.estado = ? "
            );

            parametros.add(estado);
        }

        // =====================================================
        // FECHA DESDE
        // =====================================================

        if (fechaDesde != null &&
            !fechaDesde.isBlank()) {

            sql.append(
                    "AND DATE(f.fecha_factura) >= ? "
            );

            parametros.add(
                    java.sql.Date.valueOf(
                            fechaDesde
                    )
            );
        }

        // =====================================================
        // FECHA HASTA
        // =====================================================

        if (fechaHasta != null &&
            !fechaHasta.isBlank()) {

            sql.append(
                    "AND DATE(f.fecha_factura) <= ? "
            );

            parametros.add(
                    java.sql.Date.valueOf(
                            fechaHasta
                    )
            );
        }

        // Más recientes primero
        sql.append(
                "ORDER BY f.id_factura DESC"
        );

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(
                                sql.toString()
                        )
        ) {

            // Asignar parámetros
            for (
                    int i = 0;
                    i < parametros.size();
                    i++
            ) {

                sentencia.setObject(
                        i + 1,
                        parametros.get(i)
                );
            }

            try (
                    ResultSet resultado =
                            sentencia.executeQuery()
            ) {

                while (resultado.next()) {

                    Map<String, Object> factura =
                            new HashMap<>();

                    factura.put(
                            "idFactura",
                            resultado.getInt(
                                    "id_factura"
                            )
                    );

                    factura.put(
                            "numeroFactura",
                            resultado.getString(
                                    "numero_factura"
                            )
                    );

                    factura.put(
                            "fechaFactura",
                            resultado.getTimestamp(
                                    "fecha_factura"
                            )
                    );

                    factura.put(
                            "subtotal",
                            resultado.getBigDecimal(
                                    "subtotal"
                            )
                    );

                    factura.put(
                            "descuento",
                            resultado.getBigDecimal(
                                    "descuento"
                            )
                    );

                    factura.put(
                            "impuesto",
                            resultado.getBigDecimal(
                                    "impuesto"
                            )
                    );

                    factura.put(
                            "total",
                            resultado.getBigDecimal(
                                    "total"
                            )
                    );

                    factura.put(
                            "estado",
                            resultado.getString(
                                    "estado"
                            )
                    );

                    factura.put(
                            "idCliente",
                            resultado.getInt(
                                    "id_cliente"
                            )
                    );

                    factura.put(
                            "idVehiculo",
                            resultado.getObject(
                                    "id_vehiculo"
                            )
                    );

                    factura.put(
                            "nombreCliente",
                            resultado.getString(
                                    "nombre_cliente"
                            )
                    );

                    factura.put(
                            "documentoCliente",
                            resultado.getString(
                                    "documento_cliente"
                            )
                    );

                    /*
                     * Teléfono del cliente.
                     * Se utiliza para WhatsApp.
                     */
                    factura.put(
                            "telefonoCliente",
                            resultado.getString(
                                    "telefono_cliente"
                            )
                    );

                    factura.put(
                            "placaVehiculo",
                            resultado.getString(
                                    "placa_vehiculo"
                            )
                    );

                    factura.put(
                            "marcaVehiculo",
                            resultado.getString(
                                    "marca_vehiculo"
                            )
                    );

                    factura.put(
                            "modeloVehiculo",
                            resultado.getString(
                                    "modelo_vehiculo"
                            )
                    );

                    facturas.add(
                            factura
                    );
                }
            }

        } catch (SQLException e) {

            System.err.println(
                    "Error al buscar facturas: "
                    + e.getMessage()
            );
        }

        return facturas;
    }


    /*
     * ============================================================
     * OBTENER FACTURA COMPLETA
     * ============================================================
     */
    public Map<String, Object> buscarFacturaCompleta(
            int idFactura) {

        String sql =
                "SELECT f.id_factura, " +
                "f.numero_factura, " +
                "f.fecha_factura, " +
                "f.subtotal, " +
                "f.descuento, " +
                "f.impuesto, " +
                "f.total, " +
                "f.estado, " +
                "c.nombre AS nombre_cliente, " +
                "c.documento AS documento_cliente, " +
                "c.telefono AS telefono_cliente, " +
                "c.correo AS correo_cliente, " +
                "c.direccion AS direccion_cliente, " +
                "v.placa AS placa_vehiculo, " +
                "v.marca AS marca_vehiculo, " +
                "v.modelo AS modelo_vehiculo, " +
                "v.anio AS anio_vehiculo, " +
                "v.color AS color_vehiculo, " +
                "v.tipo_vehiculo AS tipo_vehiculo " +
                "FROM facturas f " +
                "INNER JOIN clientes c " +
                "ON f.id_cliente = c.id_cliente " +
                "LEFT JOIN vehiculos v " +
                "ON f.id_vehiculo = v.id_vehiculo " +
                "WHERE f.id_factura = ?";

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(sql)
        ) {

            sentencia.setInt(
                    1,
                    idFactura
            );

            try (
                    ResultSet resultado =
                            sentencia.executeQuery()
            ) {

                if (resultado.next()) {

                    Map<String, Object> factura =
                            new HashMap<>();

                    factura.put(
                            "idFactura",
                            resultado.getInt(
                                    "id_factura"
                            )
                    );

                    factura.put(
                            "numeroFactura",
                            resultado.getString(
                                    "numero_factura"
                            )
                    );

                    factura.put(
                            "fechaFactura",
                            resultado.getTimestamp(
                                    "fecha_factura"
                            )
                    );

                    factura.put(
                            "subtotal",
                            resultado.getBigDecimal(
                                    "subtotal"
                            )
                    );

                    factura.put(
                            "descuento",
                            resultado.getBigDecimal(
                                    "descuento"
                            )
                    );

                    factura.put(
                            "impuesto",
                            resultado.getBigDecimal(
                                    "impuesto"
                            )
                    );

                    factura.put(
                            "total",
                            resultado.getBigDecimal(
                                    "total"
                            )
                    );

                    factura.put(
                            "estado",
                            resultado.getString(
                                    "estado"
                            )
                    );

                    factura.put(
                            "nombreCliente",
                            resultado.getString(
                                    "nombre_cliente"
                            )
                    );

                    factura.put(
                            "documentoCliente",
                            resultado.getString(
                                    "documento_cliente"
                            )
                    );

                    factura.put(
                            "telefonoCliente",
                            resultado.getString(
                                    "telefono_cliente"
                            )
                    );

                    factura.put(
                            "correoCliente",
                            resultado.getString(
                                    "correo_cliente"
                            )
                    );

                    factura.put(
                            "direccionCliente",
                            resultado.getString(
                                    "direccion_cliente"
                            )
                    );

                    factura.put(
                            "placaVehiculo",
                            resultado.getString(
                                    "placa_vehiculo"
                            )
                    );

                    factura.put(
                            "marcaVehiculo",
                            resultado.getString(
                                    "marca_vehiculo"
                            )
                    );

                    factura.put(
                            "modeloVehiculo",
                            resultado.getString(
                                    "modelo_vehiculo"
                            )
                    );

                    factura.put(
                            "anioVehiculo",
                            resultado.getObject(
                                    "anio_vehiculo"
                            )
                    );

                    factura.put(
                            "colorVehiculo",
                            resultado.getString(
                                    "color_vehiculo"
                            )
                    );

                    factura.put(
                            "tipoVehiculo",
                            resultado.getString(
                                    "tipo_vehiculo"
                            )
                    );

                    return factura;
                }
            }

        } catch (SQLException e) {

            System.err.println(
                    "Error al obtener factura completa: "
                    + e.getMessage()
            );
        }

        return null;
    }


    /*
     * ============================================================
     * OBTENER DETALLES DE UNA FACTURA
     * ============================================================
     */
    public List<Map<String, Object>> obtenerDetallesFactura(
            int idFactura) {

        List<Map<String, Object>> detalles =
                new ArrayList<>();

        String sql =
                "SELECT d.id_detalle, " +
                "d.id_producto, " +
                "d.tipo, " +
                "d.descripcion, " +
                "d.cantidad, " +
                "d.precio_unitario, " +
                "d.descuento, " +
                "d.subtotal, " +
                "i.codigo " +
                "FROM detalle_factura d " +
                "LEFT JOIN inventario i " +
                "ON d.id_producto = i.id_producto " +
                "WHERE d.id_factura = ? " +
                "ORDER BY d.id_detalle ASC";

        try (
                Connection conexion =
                        ConexionBD.obtenerConexion();

                PreparedStatement sentencia =
                        conexion.prepareStatement(sql)
        ) {

            sentencia.setInt(
                    1,
                    idFactura
            );

            try (
                    ResultSet resultado =
                            sentencia.executeQuery()
            ) {

                while (resultado.next()) {

                    Map<String, Object> detalle =
                            new HashMap<>();

                    detalle.put(
                            "idDetalle",
                            resultado.getInt(
                                    "id_detalle"
                            )
                    );

                    detalle.put(
                            "idProducto",
                            resultado.getObject(
                                    "id_producto"
                            )
                    );

                    detalle.put(
                            "tipo",
                            resultado.getString(
                                    "tipo"
                            )
                    );

                    detalle.put(
                            "codigo",
                            resultado.getString(
                                    "codigo"
                            )
                    );

                    detalle.put(
                            "descripcion",
                            resultado.getString(
                                    "descripcion"
                            )
                    );

                    detalle.put(
                            "cantidad",
                            resultado.getInt(
                                    "cantidad"
                            )
                    );

                    detalle.put(
                            "precioUnitario",
                            resultado.getBigDecimal(
                                    "precio_unitario"
                            )
                    );

                    detalle.put(
                            "descuento",
                            resultado.getBigDecimal(
                                    "descuento"
                            )
                    );

                    detalle.put(
                            "subtotal",
                            resultado.getBigDecimal(
                                    "subtotal"
                            )
                    );

                    detalles.add(
                            detalle
                    );
                }
            }

        } catch (SQLException e) {

            System.err.println(
                    "Error al obtener detalles de factura: "
                    + e.getMessage()
            );
        }

        return detalles;
    }


    /*
     * ============================================================
     * ELIMINAR FACTURA
     *
     * 1. Busca los productos de la factura.
     * 2. Devuelve las cantidades al inventario.
     * 3. Elimina los detalles.
     * 4. Elimina la factura.
     * 5. Confirma toda la operación.
     *
     * Si algo falla, hace ROLLBACK.
     * ============================================================
     */
    public boolean eliminar(int idFactura) {

        String sqlDetalles =
                "SELECT id_producto, cantidad " +
                "FROM detalle_factura " +
                "WHERE id_factura = ?";

        /*
         * IMPORTANTE:
         * La columna correcta es cantidad.
         */
        String sqlDevolverCantidad =
                "UPDATE inventario " +
                "SET cantidad = cantidad + ? " +
                "WHERE id_producto = ?";

        String sqlEliminarDetalles =
                "DELETE FROM detalle_factura " +
                "WHERE id_factura = ?";

        String sqlEliminarFactura =
                "DELETE FROM facturas " +
                "WHERE id_factura = ?";

        Connection conexion = null;

        try {

            conexion =
                    ConexionBD.obtenerConexion();

            // =====================================================
            // INICIAR TRANSACCIÓN
            // =====================================================

            conexion.setAutoCommit(false);

            // =====================================================
            // 1. OBTENER PRODUCTOS Y CANTIDADES
            // =====================================================

            try (
                    PreparedStatement psDetalles =
                            conexion.prepareStatement(
                                    sqlDetalles
                            )
            ) {

                psDetalles.setInt(
                        1,
                        idFactura
                );

                try (
                        ResultSet rs =
                                psDetalles.executeQuery()
                ) {

                    try (
                            PreparedStatement psCantidad =
                                    conexion.prepareStatement(
                                            sqlDevolverCantidad
                                    )
                    ) {

                        while (rs.next()) {

                            Object idProductoObjeto =
                                    rs.getObject(
                                            "id_producto"
                                    );

                            int cantidad =
                                    rs.getInt(
                                            "cantidad"
                                    );

                            /*
                             * Si id_producto es NULL:
                             * es un servicio y no modifica inventario.
                             */

                            if (
                                    idProductoObjeto != null &&
                                    cantidad > 0
                            ) {

                                int idProducto =
                                        ((Number)
                                                idProductoObjeto)
                                                .intValue();

                                psCantidad.setInt(
                                        1,
                                        cantidad
                                );

                                psCantidad.setInt(
                                        2,
                                        idProducto
                                );

                                int filas =
                                        psCantidad.executeUpdate();

                                if (filas == 0) {

                                    throw new SQLException(
                                            "No se pudo devolver " +
                                            "la cantidad del producto " +
                                            "ID: "
                                            + idProducto
                                    );
                                }
                            }
                        }
                    }
                }
            }

            // =====================================================
            // 2. ELIMINAR DETALLES
            // =====================================================

            try (
                    PreparedStatement psEliminarDetalles =
                            conexion.prepareStatement(
                                    sqlEliminarDetalles
                            )
            ) {

                psEliminarDetalles.setInt(
                        1,
                        idFactura
                );

                psEliminarDetalles.executeUpdate();
            }

            // =====================================================
            // 3. ELIMINAR FACTURA
            // =====================================================

            int filasEliminadas;

            try (
                    PreparedStatement psEliminarFactura =
                            conexion.prepareStatement(
                                    sqlEliminarFactura
                            )
            ) {

                psEliminarFactura.setInt(
                        1,
                        idFactura
                );

                filasEliminadas =
                        psEliminarFactura.executeUpdate();
            }

            // =====================================================
            // 4. VERIFICAR ELIMINACIÓN
            // =====================================================

            if (filasEliminadas == 0) {

                conexion.rollback();

                System.err.println(
                        "No se encontró la factura ID: "
                        + idFactura
                );

                return false;
            }

            // =====================================================
            // 5. CONFIRMAR
            // =====================================================

            conexion.commit();

            System.out.println(
                    "Factura eliminada correctamente. ID: "
                    + idFactura
            );

            return true;

        } catch (SQLException e) {

            // =====================================================
            // ROLLBACK
            // =====================================================

            if (conexion != null) {

                try {

                    conexion.rollback();

                } catch (SQLException ex) {

                    System.err.println(
                            "Error ejecutando rollback: "
                            + ex.getMessage()
                    );
                }
            }

            System.err.println(
                    "Error al eliminar factura: "
                    + e.getMessage()
            );

            return false;

        } finally {

            if (conexion != null) {

                try {

                    conexion.setAutoCommit(true);

                } catch (SQLException ignored) {
                }

                try {

                    conexion.close();

                } catch (SQLException ignored) {
                }
            }
        }
    }


    /*
     * ============================================================
     * MAPEAR FACTURA
     * ============================================================
     */
    private Factura mapearFactura(
            ResultSet resultado)
            throws SQLException {

        Factura factura =
                new Factura();

        factura.setIdFactura(
                resultado.getInt(
                        "id_factura"
                )
        );

        factura.setNumeroFactura(
                resultado.getString(
                        "numero_factura"
                )
        );

        factura.setIdCliente(
                resultado.getInt(
                        "id_cliente"
                )
        );

        // Vehículo
        int idVehiculo =
                resultado.getInt(
                        "id_vehiculo"
                );

        factura.setIdVehiculo(
                resultado.wasNull()
                        ? null
                        : idVehiculo
        );

        // Fecha
        Timestamp fecha =
                resultado.getTimestamp(
                        "fecha_factura"
                );

        if (fecha != null) {

            factura.setFechaFactura(
                    fecha.toLocalDateTime()
            );
        }

        // Valores
        factura.setSubtotal(
                resultado.getBigDecimal(
                        "subtotal"
                )
        );

        factura.setDescuento(
                resultado.getBigDecimal(
                        "descuento"
                )
        );

        factura.setImpuesto(
                resultado.getBigDecimal(
                        "impuesto"
                )
        );

        factura.setTotal(
                resultado.getBigDecimal(
                        "total"
                )
        );

        factura.setEstado(
                resultado.getString(
                        "estado"
                )
        );

        return factura;
    }


    /*
     * ============================================================
     * MÉTODO AUXILIAR
     * Evita valores BigDecimal NULL
     * ============================================================
     */
    private BigDecimal valorSeguro(
            BigDecimal valor) {

        return valor == null
                ? BigDecimal.ZERO
                : valor;
    }


    /*
     * ============================================================
     * CERRAR RECURSOS
     * ============================================================
     */
    private void cerrarRecursos(
            ResultSet rs,
            PreparedStatement ps,
            Connection conn) {

        if (rs != null) {

            try {

                rs.close();

            } catch (SQLException ignored) {
            }
        }

        if (ps != null) {

            try {

                ps.close();

            } catch (SQLException ignored) {
            }
        }

        if (conn != null) {

            try {

                conn.close();

            } catch (SQLException ignored) {
            }
        }
    }
}