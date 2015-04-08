<%-- 
    Document   : displaySim
    Created on : 08-Apr-2015, 20:56:21
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
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Results</h1>
        
        <%!
        public class Similarity {
            
            Connection con = null; 
            PreparedStatement pst = null; 
            ResultSet rs = null;
            
            
            public Similarity(){
                try{
                    con = DriverManager.getConnection("jdbc:mysql://danu6.it.nuigalway.ie:3306/mydb1803","mydb1803gk","ki1riw"); 
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
                
            }
            
            public ResultSet getID(long thres, long accept){
                
                try{
             
                    pst = con.prepareStatement("Select translations.src_term_id, translations.targ_term_id, translations.similarity_score, translations.accepted From translations Where translations.similarity_score > ? And translations.accepted = ?");
                    pst.setLong(1, thres);
                    pst.setLong(2, accept);
                    
                    rs = pst.executeQuery();
   
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
                return rs;
            }
            
            public ResultSet getTerm(long id_1, long id_2){
                
                try{
             
                    pst = con.prepareStatement("Select t1.term, t2.term From terms t1, terms t2 Where t1.id = ? And t2.id = ?");
                    pst.setLong(1, id_1);
                    pst.setLong(2, id_2);
                    
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
        
        long threshold=0;
        long accepted=0;
        Similarity s = new Similarity();
        ResultSet terms=null;
        ResultSet term_ids=null;

        if(request.getParameter("simValue") != null){
            threshold = Integer.parseInt(request.getParameter("simValue"));
        }
        if(request.getParameter("accepted") != null){
            accepted = Integer.parseInt(request.getParameter("accepted"));
        }
        
        term_ids = s.getID(threshold, accepted);
        Multimap <String, String> term_map = ArrayListMultimap.create();
        
        while(term_ids.next()){
            long id_1 = term_ids.getLong(1);
            long id_2 = term_ids.getLong(2);
            long similarity = term_ids.getLong(3);
            String hold = ""+id_2+","+similarity;
            
            terms=s.getTerm(id_1, id_2);
            
            while(terms.next()){
                String term_1 = terms.getString(1);
                String term_2 = terms.getString(2);
                term_map.put(term_1, term_2);
            }
                
         }
        
        for(Map.Entry<String, String> entry: term_map.entries()){
             out.println("Source...key is :" + entry.getKey() + "  value is :" + entry.getValue());
        }
        
        %>
        
        <% if(!term_map.isEmpty()){
            %>    
             <table class="mytable" border="1">
                    <thead>
                    <tr>
                        <th colspan="2">Source Category Translations </th>
                    </tr>
                    </thead>
            <% 
            for(Map.Entry<String, String> entry: term_map.entries()) { 
                   
     
            %>
                    <tr>
                        <td>Similiarity Score</td>
                        <td><%=threshold%></td>
                    </tr>
            
                    <tr>
                        <td>Source Term</td>
                        <td><%= entry.getKey() %></td>
                    </tr>
                     <tr>
                        <td>Target Term</td>
                        <td><%= entry.getValue() %></td>
                    </tr> 
                    
            <% } %>
            </table> 
            <% } else {
             
                 out.println("No results");
            }
            %>

        
        %>
    </body>
</html>
