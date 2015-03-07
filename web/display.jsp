<%-- 
    Document   : display
    Created on : 03-Mar-2015, 17:26:33
    Author     : Katie
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<% Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Selecting Specific Data from a DB</title>
    </head>
    <body>
        <h1>Selecting Specific Data from a DB</h1>
        <%!
         public class Translate {
            
            Connection con = null; 
            PreparedStatement pst = null; 
            ResultSet rs = null;
            
            
            public Translate(){
                try{
                    con = DriverManager.getConnection("jdbc:mysql://danu6.it.nuigalway.ie:3306/mydb1803","mydb1803gk","ki1riw");

                    pst = con.prepareStatement(
                            "SELECT id, language FROM languages WHERE id = ?");
                    
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
            }
            
            
            public ResultSet getTranslation(int id){
                
                try{
                    
                    pst.setInt(1, id);
                    rs = pst.executeQuery();
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
                return rs;
            }
        }
          
        %>
        <%
            int l_id=0;
            
            if(request.getParameter("source_language") != null){
                l_id = Integer.parseInt(request.getParameter("source_language"));
            }

            Translate translation = new Translate();
            ResultSet rs_trans = translation.getTranslation(l_id);
            
        %>
        
        <table border="1">
           
            <tbody>
                <tr>
                    <td>Language id:</td>
                    <td>Language: </td>
                </tr>
                <% while (rs_trans.next()) {%>
                <tr>
                    <td><%= rs_trans.getInt("id")%></td>
                    <td><%= rs_trans.getString("language")%></td>
                </tr>
                <% } %>
            </tbody>
        </table>

        
    </body>
</html>
