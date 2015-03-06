<%-- 
    Document   : display
    Created on : 03-Mar-2015, 17:26:33
    Author     : Katie
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        
        <%
            Connection con = null; 
            PreparedStatement pst = null; 
            ResultSet rs = null;
            
                try{
                    con = DriverManager.getConnection("jdbc:mysql://danu6.it.nuigalway.ie:3306/mydb1803","mydb1803gk","ki1riw");

                    pst = con.prepareStatement(
                        "SELECT id, language from languages");
                    
                    rs = pst.executeQuery();
                    
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
        
        %>
                
        
        <form name="selForm" action="display.jsp" method="POST">
            <table border="1">
                <thead>
                    <tr>
                        <th>Query</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>LANGUAGE</td>
                       <td><select name="language_id">
                               <% while(rs.next()){%>
                               <option value="<%= rs.getInt(1)%>"><%= rs.getString(2)%></option>
                               <% } %>
                           </select></td>
                    </tr>
                </tbody>
            </table>
            <input type="reset" value="Reset" name="reset" />
            <input type="submit" value="Submit" name="submit" />
        </form>
    </body>
</html>
