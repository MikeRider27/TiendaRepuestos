package Logica;

import DAO.ServicioDAO;
import Interfaces.iServicioLogica;
import Modelo.Servicio;
import java.util.List;

public class ServicioLogica implements iServicioLogica {
    private ServicioDAO servicioDAO;

    @Override
    public List<Servicio> listar() {
        servicioDAO = new ServicioDAO();
        return servicioDAO.listar();
    }
}
