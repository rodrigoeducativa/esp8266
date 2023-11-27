<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.IOException"%>
<%@ page import="java.sql.SQLException" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cadastro via Excel</title>
    </head>
    <body>
<%
try (BufferedReader br = new BufferedReader(new FileReader("C:\\Users\\Rodrigo\\Desktop\\Projeto PIbanco\\web\\decibeis.csv"))){
    //conexao com o banco de dados
    Connection conecta;
    Class.forName("com.mysql.cj.jdbc.Driver");
    String url = "jdbc:mysql://localhost:3306/bancopi";
    conecta = DriverManager.getConnection(url, "root", "1234");
    String linha = "";

    while ((linha = br.readLine()) != null) {
        // Verifica se a linha é um cabeçalho ou está em branco
        if (linha.trim().startsWith("TIME") || linha.trim().isEmpty()) {
            continue; // Pula para a próxima iteração do loop
        }

        String[] dados = linha.split(";");
        //Limpa o valor caso exista algum outro caracter oculto e/ou diferente de numero
        String horaString = dados[0].replaceAll("[^0-9]","");
        if (dados.length > 1 && dados[1] != null && !dados[1].isEmpty()) {
            int decibeis = Integer.parseInt(dados[1]);

            // Formata a hora no estilo HH:mm:ss
            String horaFormatada = horaString.substring(0, 1) + ":" + horaString.substring(1, 3) + ":" + horaString.substring(3, 5);

            // Cria um objeto java.sql.Time
            java.sql.Time hora = java.sql.Time.valueOf(horaFormatada);

            // Restante do seu código...
            
            String sql = "INSERT INTO ruido(hora, nivelDecibel) VALUES (?, ?)";
            PreparedStatement stat = conecta.prepareStatement(sql);
            stat.setTime(1, hora);
            stat.setInt(2, decibeis);

            stat.executeUpdate();
            out.print("hora: " + horaFormatada + " decibeis: " + decibeis);
            out.print("O arquivo foi carregado com sucesso");
        } else {
            // Lógica para lidar com o caso em que dados[1] não é válido
        }
    }
    br.close();
} catch (IOException | SQLException | ClassNotFoundException e) {
    e.printStackTrace();
}
%>
    </body>
</html>
