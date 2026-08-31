<%--
    Document   : ReporteTipoServicio
    Author     : Los Irresistibles
--%>

<%@page import="Modelo.TipoServicio"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="WEB-INF/jspf/validacion.jspf" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <%@include file="WEB-INF/jspf/head.jspf" %>
        <title>Reporte de Tipo de Servicio</title>
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
                    <h2><strong>Reporte de Tipo de Servicio</strong></h2>
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
                        <td><b>Descripción</b></td>
                    </thead>
                    <%
                        List<TipoServicio> lstTipoServicio = (List<TipoServicio>) session.getAttribute("listaReporteTipoServicio");
                        if (lstTipoServicio != null) {
                            for (int i = 0; i < lstTipoServicio.size(); i++) {
                                TipoServicio tipoServicio = lstTipoServicio.get(i);
                    %>
                    <tbody>
                        <tr>
                            <td><center><%=i + 1%></center></td>
                            <td><%=tipoServicio.getDescripcion()%></td>
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
