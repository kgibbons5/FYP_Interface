<%-- 
    Document   : display
    Created on : 03-Mar-2015, 17:26:33
    Author     : Katie
--%>
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
         public class Translate {
            
            Connection con = null; 
            PreparedStatement pst = null; 
            ResultSet rs = null;
            
            
            public Translate(){
                try{
                    con = DriverManager.getConnection("jdbc:mysql://danu6.it.nuigalway.ie:3306/mydb1803","mydb1803gk","ki1riw"); 
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
            }
            
            
            public ResultSet getTermID(long src_lang_id,String term){
                
                try{
             
                    pst = con.prepareStatement("Select id from terms where language_id= ? and term like ?");
                    pst.setLong(1, src_lang_id);
                    pst.setString(2, term);
                    
                    rs = pst.executeQuery();
   
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
                return rs;
            }
            
            public ResultSet getTranslationID(long src_term_id,long targ_lang){
                
                try{
                    pst = con.prepareStatement("select * from translations left join terms on (translations.src_term_id = terms.id or translations.targ_term_id = terms.id)  where (src_term_id = ? or targ_term_id= ?)and terms.language_id=?");
                    pst.setLong(1, src_term_id);
                    pst.setLong(2, src_term_id);
                    pst.setLong(3, targ_lang);
                    rs = pst.executeQuery();
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
                return rs;
            }
            
           
            
            public ResultSet getTranslation(long id_1,long id_2){
                
                try{
                    pst = con.prepareStatement("Select terms.term, languages.language, terms1.term As term1, languages1.language As language1, categories.category From terms Inner Join languages On terms.language_id = languages.id Inner Join terms_has_categories On terms_has_categories.terms_id = terms.id Inner Join categories On terms_has_categories.categories_id = categories.id, terms terms1 Inner Join languages languages1 On terms1.language_id = languages1.id Where terms.id = ? And terms1.id = ?");
                    pst.setLong(1, id_1);
                    pst.setLong(2, id_2);
                    rs = pst.executeQuery();
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
                return rs;
            }
            
            
            public ResultSet checkSynonyms(String term){
                
                try{
                    pst = con.prepareStatement("Select * from synonyms where synonym like ?");
                    pst.setString(1, term);
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
            String src_term = new String();
            long src_lang=0;
            long targ_lang=0;
            long source_id=0;
            long target_id=0;
            
            if(request.getParameter("source_term") != null){
                src_term = request.getParameter("source_term");
            }
            
            if(request.getParameter("source_language") != null){
                src_lang =  Integer.parseInt(request.getParameter("source_language"));
            }
            
             if(request.getParameter("target_language") != null){
                targ_lang =  Integer.parseInt(request.getParameter("target_language"));
            }

            out.println("Source term is " +src_term);
            out.println("Source language id is " +src_lang);
            
            Translate t = new Translate();
            ResultSet rs_ids = t.getTermID(src_lang, src_term);
            ResultSet rs_trans=null;
            ResultSet rs_trans_ids=null;
            ResultSet rs_syn_id=null;
            
            
            List<Long> ids = new ArrayList<Long>();
            
            Multimap <Long, Long> translation_ids = ArrayListMultimap.create();
            Multimap <String, String> translations = ArrayListMultimap.create();
            
            while(rs_ids.next()){
                long id = rs_ids.getLong("id");
                ids.add(id);
            }
            
            for(int i=0; i<ids.size(); i++)
            {
                out.println("Id is " +ids.get(i));
                out.println("Target language id is " +targ_lang);
                rs_trans_ids = t.getTranslationID(ids.get(i),targ_lang);
                
                while(rs_trans_ids.next())
                {
                    source_id = rs_trans_ids.getLong("src_term_id");
                    target_id = rs_trans_ids.getLong("targ_term_id");
                    //out.println(" SOURCE TERM ID IS " +source_id + "TARGET TERM ID IS "+target_id);
                    translation_ids.put(source_id, target_id);
                    
                }
         
                //check if src_term or targ_term in translation table
                long key = (Long) translation_ids.keySet().toArray()[0];
                out.println(" THE KEY IS; " +key);
                
                for(Map.Entry<Long, Long> entry: translation_ids.entries())
                {
                    if(ids.get(0)==entry.getKey()){
                        
                        out.println("Source...key is :" + entry.getKey() + "  value is :" + entry.getValue());
                        rs_trans = t.getTranslation(entry.getKey(), entry.getValue());
                       
                        while(rs_trans.next())
                        {
                            out.println("  in rs_trans");
                              
                            String term_1 = rs_trans.getString(1);
                            String lang_1 = rs_trans.getString(2);
                            String term_2 = rs_trans.getString(3);
                            String lang_2 = rs_trans.getString(4);
                            String cat = rs_trans.getString(5);
                            String hold = ""+lang_1+","+term_2+","+lang_2+","+cat+"";
                            
                            translations.put(term_1,hold);

                        }
                    }
                    else{
                        
                        out.println("Target...key is :" + entry.getKey() + "  value is :" + entry.getValue());
                        rs_trans = t.getTranslation(entry.getValue(),entry.getKey());
                        
                        
                        
                       
                        while(rs_trans.next())
                        {
                            out.println("  in rs_trans");
                              
                            String term_1 = rs_trans.getString(1);
                            String lang_1 = rs_trans.getString(2);
                            String term_2 = rs_trans.getString(3);
                            String lang_2 = rs_trans.getString(4);
                            String cat = rs_trans.getString(5);
                            String hold = ""+lang_1+","+term_2+","+lang_2+","+cat+"";
                            
                            translations.put(term_1,hold);
                            
                        }
                    }
                }   
                
            }
            
            %>
             
            <a href="index.jsp"><button> Back </button></a>    
            <p>
            <p>
                
            <table class="mytable" border="1">
            <% 
            for(Map.Entry<String, String> entry: translations.entries()) { 
                String holder[] = new String[4];
                holder = entry.getValue().split(",");    
     
                %>
                    <tr>
                        <td colspan="2"><%= holder[3]%></td>
                        
                    </tr>
                    <tr>
                        <td class ="lang"><%= holder[0] %></td>
                        <td class ="term"><%= entry.getKey() %></td>
                    </tr>
                     <tr>
                        <td><%= holder[2]%></td>
                        <td><%= holder[1]%></td>   
                    </tr>
                    
            <% } %>
            </table>    
            
            <% 
                if(rs_trans == null)
                {
                    out.println("No match found .... searching synonyms for...."+src_term);
                    rs_syn_id = t.checkSynonyms(src_term);
                    
                    if(rs_syn_id == null)
                    {
                        out.println("No synonyms found");
                    }
                    
                    while(rs_syn_id.next())
                    {
                        out.println("Synonyms found");
                        
                       
                    }
                }
            %>
            <p>
            <p>
            <p>
    </body>
</html>
