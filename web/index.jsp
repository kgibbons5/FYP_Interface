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
        <style>
            table, th, td {
                border: 1px solid black;
                border-collapse: collapse;
            }
            th, td{
                padding: 5px;
            }
        </style>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Selecting Specific Data from a DB</title>
    </head>
    <body>
        <h1>Selecting Specific Data from a DB</h1>
        
        <%
            Connection con = null; 
            PreparedStatement pst1 = null;
            PreparedStatement pst2 = null;
            PreparedStatement pst3 = null; 
            ResultSet rs1 = null;
            ResultSet rs2 = null;
            ResultSet rs3 = null;
            
                try{
                    con = DriverManager.getConnection("jdbc:mysql://danu6.it.nuigalway.ie:3306/mydb1803","mydb1803gk","ki1riw");

                    //source language
                    pst1 = con.prepareStatement(
                        "SELECT * from languages");
                    
                    //target language
                    pst2 = con.prepareStatement(
                        "SELECT * from languages");
                    
                    
                    rs1 = pst1.executeQuery();
                    rs2 = pst2.executeQuery();
                    
              
        %>
                
        
        <form name="selForm" action="display.jsp" method="POST">
            <table style:="width:100%">
                    <tr>
                        <th>Source Term</th>
                        <th>Source Language</th>
                        <th>Target Language</th>                      
                    </tr>
                    <tr>
                        <td>
                            <input type="text" name="source_term" value="" size="30" />
                       </td>
                       <td><select name="source_language">
                               <% while(rs1.next()){%>
                               <option value="<%= rs1.getInt(1)%>"><%= rs1.getString(2)%></option>
                               <% } %>
                           </select>
                       </td>
                       <td><select name="target_language">
                               <% while(rs2.next()){%>
                               <option value="<%= rs2.getInt(1)%>"><%= rs2.getString(2)%></option>
                               <% } %>
                           </select>
                       </td>
                    </tr>
            </table>
            <%      
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
                finally{
                    if(rs1!=null) try{rs1.close();}catch(Exception e){}
                    if(rs2!=null) try{rs1.close();}catch(Exception e){}
                  
                    
                }
        %>               
                           
                           
            <input type="reset" value="Reset" name="reset" />
            <input type="submit" value="Submit" name="submit" />
        </form>
    </body>
</html>
