<%-- 
    Document   : displayCategory
    Created on : 07-Apr-2015, 17:19:15
    Author     : Katie
--%>

<%@page import="org.tartarus.snowball.ext.englishStemmer"%>
<%@page import="java.io.BufferedReader" %>
<%@page import="java.io.DataOutputStream" %>
<%@page import="java.io.InputStreamReader" %>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL" %>
<%@page import="javax.net.ssl.HttpsURLConnection" %>
<%@page import="com.google.common.collect.Multimap"%>
<%@page import="com.google.common.*"%>
<%@page import="com.google.common.collect.ArrayListMultimap"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.tartarus.snowball.*"%>
<%@page import="java.util.regex.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<% Class.forName("com.mysql.jdbc.Driver"); %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style>
           table.mytable {
                width: 50%;
                height: 50%;
                border: 1px solid black;
                border-collapse: collapse;
                border-spacing: 10px 10px;
            }
            
            td{
                padding-top: 10px;
                padding-bottom: 15px;
                
            }
            
            .term {
                width: 10%;
            }
            
            .lang {
                width: 10%;
            }
        
        </style>
        <title>Results</title>
    </head>
    <body bgcolor="#FFFFDF">
        <h1>Hello World!</h1>
    </body>
</html>
