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
            .button{
               font-size: 15px;
                
            }
            
        </style>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Glossaries</title>
    </head>
        <body bgcolor="#FFFFDF">
        <h1>Search Options</h1>
        <p><font size="4">Search by Term &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font><a href="searchTerm.jsp"><button class="button">Search </button></a>
        </p>
        <p>
        <p>
        <p>
        <p>
        <p>  
        <p><font size="4">Search by Category &nbsp; </font><a href="searchCategory.jsp"><button class="button">Search </button></a>
        </p>
        
        
    </body>
</html>
