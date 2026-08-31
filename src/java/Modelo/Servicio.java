package Modelo;

public class Servicio {
    private int idServicio;
    private String descripcion;
    private double precio;
    private TipoServicio tipoServicio;

    public Servicio() {
    }

    public Servicio(int idServicio, String descripcion, double precio, TipoServicio tipoServicio) {
        this.idServicio = idServicio;
        this.descripcion = descripcion;
        this.precio = precio;
        this.tipoServicio = tipoServicio;
    }

    public int getIdServicio() {
        return idServicio;
    }

    public void setIdServicio(int idServicio) {
        this.idServicio = idServicio;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public TipoServicio getTipoServicio() {
        return tipoServicio;
    }

    public void setTipoServicio(TipoServicio tipoServicio) {
        this.tipoServicio = tipoServicio;
    }
}
