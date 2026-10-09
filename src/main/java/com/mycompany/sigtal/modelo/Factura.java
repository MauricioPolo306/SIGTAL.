package com.mycompany.sigtal.modelo;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Factura {

    private int idFactura;
    private String numeroFactura;
    private int idCliente;
    private Integer idVehiculo;
    private LocalDateTime fechaFactura;
    private BigDecimal subtotal;
    private BigDecimal descuento;
    private BigDecimal impuesto;
    private BigDecimal total;
    private String estado;

    public Factura() {
    }

    public Factura(
            String numeroFactura,
            int idCliente,
            Integer idVehiculo,
            LocalDateTime fechaFactura,
            BigDecimal subtotal,
            BigDecimal descuento,
            BigDecimal impuesto,
            BigDecimal total,
            String estado) {

        this.numeroFactura = numeroFactura;
        this.idCliente = idCliente;
        this.idVehiculo = idVehiculo;
        this.fechaFactura = fechaFactura;
        this.subtotal = subtotal;
        this.descuento = descuento;
        this.impuesto = impuesto;
        this.total = total;
        this.estado = estado;
    }

    public Factura(
            int idFactura,
            String numeroFactura,
            int idCliente,
            Integer idVehiculo,
            LocalDateTime fechaFactura,
            BigDecimal subtotal,
            BigDecimal descuento,
            BigDecimal impuesto,
            BigDecimal total,
            String estado) {

        this.idFactura = idFactura;
        this.numeroFactura = numeroFactura;
        this.idCliente = idCliente;
        this.idVehiculo = idVehiculo;
        this.fechaFactura = fechaFactura;
        this.subtotal = subtotal;
        this.descuento = descuento;
        this.impuesto = impuesto;
        this.total = total;
        this.estado = estado;
    }

    public int getIdFactura() {
        return idFactura;
    }

    public void setIdFactura(int idFactura) {
        this.idFactura = idFactura;
    }

    public String getNumeroFactura() {
        return numeroFactura;
    }

    public void setNumeroFactura(String numeroFactura) {
        this.numeroFactura = numeroFactura;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public Integer getIdVehiculo() {
        return idVehiculo;
    }

    public void setIdVehiculo(Integer idVehiculo) {
        this.idVehiculo = idVehiculo;
    }

    public LocalDateTime getFechaFactura() {
        return fechaFactura;
    }

    public void setFechaFactura(LocalDateTime fechaFactura) {
        this.fechaFactura = fechaFactura;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public BigDecimal getDescuento() {
        return descuento;
    }

    public void setDescuento(BigDecimal descuento) {
        this.descuento = descuento;
    }

    public BigDecimal getImpuesto() {
        return impuesto;
    }

    public void setImpuesto(BigDecimal impuesto) {
        this.impuesto = impuesto;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return numeroFactura + " - $" + total;
    }
}