package Controladores;

import Interfaces.iServicioLogica;
import Interfaces.iTipoServicioLogica;
import Logica.ServicioLogica;
import Logica.TipoServicioLogica;
import Modelo.Servicio;
import Modelo.TipoServicio;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

@WebServlet(name = "ReporteControlador", urlPatterns = {"/ReporteControlador"})/*url para el navegador*/
public class ReporteControlador extends HttpServlet {

    private static Logger logger = Logger.getLogger(ReporteControlador.class.getName());

    private iTipoServicioLogica tipoServicioService;
    private iServicioLogica servicioService;

    private HttpSession sesion;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String accion = request.getParameter("accion");

        logger.info("processRequest: " + accion);

        sesion = request.getSession();
        if (sesion.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        if (accion != null) {
            if (accion.equals("tipoServicio")) {
                reporteTipoServicio(request, response);
                return;
            }
            if (accion.equals("servicio")) {
                reporteServicio(request, response);
            }
        }
    }

    protected void reporteTipoServicio(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.info("reporteTipoServicio");
        try {
            tipoServicioService = new TipoServicioLogica();
            List<TipoServicio> lstTipoServicio = tipoServicioService.buscar("", 0, Integer.MAX_VALUE);

            sesion.removeAttribute("listaReporteTipoServicio");
            sesion.setAttribute("listaReporteTipoServicio", lstTipoServicio);
            response.sendRedirect("ReporteTipoServicio.jsp");
        } catch (Exception e) {
            logger.error("reporteTipoServicio: " + e.getMessage());
        }
    }

    protected void reporteServicio(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.info("reporteServicio");
        try {
            servicioService = new ServicioLogica();
            List<Servicio> lstServicio = servicioService.listar();

            sesion.removeAttribute("listaReporteServicio");
            sesion.setAttribute("listaReporteServicio", lstServicio);
            response.sendRedirect("ReporteServicio.jsp");
        } catch (Exception e) {
            logger.error("reporteServicio: " + e.getMessage());
        }
    }
}
