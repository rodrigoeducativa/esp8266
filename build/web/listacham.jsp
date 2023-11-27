
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>

<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset="ISO-8859-1">
        
        <link rel="stylesheet" href="tabela.css"/>
        <title>Listagem de Chamados</title>
    </head>
    <body>
        <%

            try {
                Connection conecta;
                PreparedStatement stat;
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/bancopi";
                conecta = DriverManager.getConnection(url, "root", "1234");
                //Listar chamados
                stat = conecta.prepareStatement("SELECT * FROM ruido Order by id");
                ResultSet resultado = stat.executeQuery();
        %>
<table>
    <thead>
        <tr>
            <th>Id</th>
            <th>Hora</th>
            <th>Nivel (Decibel)</th>
        </tr>
    </thead>
    <tbody>
        <% while (resultado.next()) { %>
            <tr>
                <td><%=resultado.getString("id")%></td>
                <td><%=resultado.getString("hora")%></td>
                <td class="decibel-cell" data-valor="<%=resultado.getString("nivelDecibel")%>">
                    <%=resultado.getString("nivelDecibel")%>
                </td>
            </tr>
        <% } %>
    </tbody>
</table>
    <%
        } catch (Exception erro) {
            out.print("Mensagem de erro: " + erro.getMessage());
        }


    %>
</body>
</html>
