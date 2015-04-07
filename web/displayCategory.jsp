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
        <h1>Results</h1>
        <%!
        public class Category {
            
            Connection con = null; 
            PreparedStatement pst = null; 
            ResultSet rs = null;
            
            
            public Category(){
                try{
                    con = DriverManager.getConnection("jdbc:mysql://danu6.it.nuigalway.ie:3306/mydb1803","mydb1803gk","ki1riw"); 
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
            }
            
            public String getCat(long cat_id){
                
                String cat=null;
                
                try{
             
                    pst = con.prepareStatement("Select category from categories where categories.id = ?");
                    pst.setLong(1, cat_id);
                   
                    
                    rs = pst.executeQuery();
                    
                    if(rs.next()) {  
                        cat = rs.getString(1);
                    }
   
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
                
                return cat;
                
            }
            
            
            public ResultSet getID(long lang_id, long cat_id){
                
                try{
             
                    pst = con.prepareStatement("Select terms.id From terms Inner Join terms_has_categories On terms_has_categories.terms_id = terms.id Inner Join languages On terms.language_id = languages.id Inner Join categories On terms_has_categories.categories_id = categories.id Where terms.language_id = ? And categories.id = ?");
                    pst.setLong(1, lang_id);
                    pst.setLong(2, cat_id);
                    
                    rs = pst.executeQuery();
   
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
                return rs;
            }
            
            
            public ResultSet getTerms(long src_id, long targ_id){
                
                try{
             
                    pst = con.prepareStatement("Select terms.term, terms1.term As term1 From terms Inner Join translations On translations.src_term_id = terms.id Or translations.targ_term_id = terms.id, terms terms1 Inner Join translations translations1 On translations1.src_term_id = terms1.id Or translations1.targ_term_id = terms1.id Where terms.id = ? And terms1.id = ?");
                    pst.setLong(1, src_id);
                    pst.setLong(2, targ_id);
                    
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
            long category_id=0;
            long src_lang=0;
            long targ_lang=0;
            Category c = new Category();
            List<Long> src_ids = new ArrayList<Long>();
            List<Long> targ_ids = new ArrayList<Long>();
            Multimap <Long, Long> term_ids = ArrayListMultimap.create();
            Multimap <String, String> terms = ArrayListMultimap.create();
            ResultSet rs_terms=null;


            if(request.getParameter("category") != null){
                category_id = Integer.parseInt(request.getParameter("category"));
            }
            
            if(request.getParameter("source_language") != null){
                src_lang =  Integer.parseInt(request.getParameter("source_language"));
            }
            
            if(request.getParameter("target_language") != null){
                targ_lang =  Integer.parseInt(request.getParameter("target_language"));
            }

            
            String category = c.getCat(category_id);
            out.println("category is " +category);
            ResultSet rs_src_ids = c.getID(src_lang, category_id);
            
            while(rs_src_ids.next()){
                long id = rs_src_ids.getLong("id");
                src_ids.add(id);
            }
            
            ResultSet rs_targ_ids = c.getID(targ_lang, category_id);
            while(rs_targ_ids.next()){
                long id = rs_targ_ids.getLong("id");
                targ_ids.add(id);
            }
            
            
            for(int i=0; i<src_ids.size(); i++)
            {
                out.println("src Id is " +src_ids.get(i));
            }
            
            for(int i=0; i<targ_ids.size(); i++)
            {
                out.println("targ Id is " +targ_ids.get(i));
            }
            
            
             for(int i=0; i<src_ids.size(); i++)
            {
                
                for(int j=0; j<targ_ids.size(); j++)
                {
                    term_ids.put(src_ids.get(i), targ_ids.get(j));
                    
                }        
            
            }
            
            for(Map.Entry<Long, Long> entry: term_ids.entries())
            {
                out.println("Source...key is :" + entry.getKey() + "  value is :" + entry.getValue());
                rs_terms=c.getTerms(entry.getKey(), entry.getValue());
                
                while(rs_terms.next())
                {
                    out.println("  in rs_trans");
                              
                    String term_1 = rs_terms.getString(1);
                    String term_2 = rs_terms.getString(2);
                    terms.put(term_1, term_2);
                }
                
            }
            
            
            for(Map.Entry<String, String> entry: terms.entries())
            {
                out.println("Source...key is :" + entry.getKey() + "  value is :" + entry.getValue());
            }
            %>
            
            
            <% if(!terms.isEmpty()){
            %>    
             <table class="mytable" border="1">
                    <thead>
                    <tr>
                        <th colspan="2">Category Translations </th>
                    </tr>
                    </thead>
            <% 
            for(Map.Entry<String, String> entry: terms.entries()) { 
                   
     
            %>
                    <tr>
                        <td>Category</td>
                        <td><%=category%></td>
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
            <% }    
        %>
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    </body>
</html>