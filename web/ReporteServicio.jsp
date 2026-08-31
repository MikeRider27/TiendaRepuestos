<%--
    Document   : ReporteServicio
    Author     : Los Irresistibles
--%>

<%@page import="Modelo.Servicio"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="WEB-INF/jspf/validacion.jspf" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <%@include file="WEB-INF/jspf/head.jspf" %>
        <title>Reporte de Servicio</title>
        <style>
            @media print {
                .no-print, header, footer { display: none !important; }
            }
        </style>
    </head>

    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <main>
            <section class="jumbotron">
                <div class="container">
                    <h2><strong>Reporte de Servicio</strong></h2>
                </div>
            </section>
            <section class="container">
                <div class="no-print" style="margin-bottom: 15px;">
                    <button type="button" class="btn btn-primary" onclick="window.print()">
                        <span class="glyphicon glyphicon-print"></span> Imprimir
                    </button>
                </div>
                <table border="1" class="table table-hover tabla-resultados">
                    <thead align="center" class="thead-listado">
                        <td><b>#</b></td>
                        <td><b>Servicio</b></td>
                        <td><b>Tipo de Servicio</b></td>
                        <td><b>Precio</b></td>
                    </thead>
                    <%
                        List<Servicio> lstServicio = (List<Servicio>) session.getAttribute("listaReporteServicio");
                        if (lstServicio != null) {
                            for (int i = 0; i < lstServicio.size(); i++) {
                                Servicio servicio = lstServicio.get(i);
                    %>
                    <tbody>
                        <tr>
                            <td><center><%=i + 1%></center></td>
                            <td><%=servicio.getDescripcion()%></td>
                            <td><%=servicio.getTipoServicio().getDescripcion()%></td>
                            <td><center>S/ <%=String.format("%.2f", servicio.getPrecio())%></center></td>
                        </tr>
                    </tbody>
                    <%
                            }
                        }
                    %>
                </table>
            </section>
        </main>
        <%@include file="WEB-INF/jspf/footer.jspf" %>
    </body>
</html>
