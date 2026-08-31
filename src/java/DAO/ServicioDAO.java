package DAO;

import Interfaces.iServicioDAO;
import Modelo.Servicio;
import Modelo.TipoServicio;
import Util.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class ServicioDAO implements iServicioDAO {
    private static Logger logger = Logger.getLogger(ServicioDAO.class.getName());
    private Conexion con;
    private Connection cn;
    private ResultSet rs;
    private PreparedStatement ps;
    private String sql;

    @Override
    public List<Servicio> listar() {
        logger.info("Listar Servicio");
        sql = "select s.idServicio, p.descripcion, p.precio, ts.idTipoServicio, ts.descripcion as tsDescripcion "
                + "from servicio s "
                + "inner join producto p on s.idProducto = p.idProducto "
                + "inner join tiposervicio ts on s.idTipoServicio = ts.idTipoServicio "
                + "order by s.idServicio";

        List<Servicio> lstServicio = null;
        Servicio servicio;
        TipoServicio tipoServicio;
        try {
            con = new Conexion();
            cn = con.getConexion();
            cn.setAutoCommit(false);
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            lstServicio = new ArrayList<>();

            while (rs.next()) {
                servicio = new Servicio();
                servicio.setIdServicio(rs.getInt("idServicio"));
                servicio.setDescripcion(rs.getString("descripcion"));
                servicio.setPrecio(rs.getDouble("precio"));

                tipoServicio = new TipoServicio();
                tipoServicio.setIdTipoServicio(rs.getInt("idTipoServicio"));
                tipoServicio.setDescripcion(rs.getString("tsDescripcion"));
                servicio.setTipoServicio(tipoServicio);

                lstServicio.add(servicio);
            }
        } catch (Exception e) {
            logger.info("Error al listar Servicio: " + e.getMessage());
        } finally {
            con.cerrarConexion(cn);
        }
        return lstServicio;
    }
}
