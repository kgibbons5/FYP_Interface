<%-- 
    Document   : display
    Created on : 03-Mar-2015, 17:26:33
    Author     : Katie
--%>

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
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
            }
            
            
            public ResultSet getTermID(long src_lang_id,String term){
                
                try{
                  //con = DriverManager.getConnection("jdbc:mysql://danu6.it.nuigalway.ie:3306/mydb1803","mydb1803gk","ki1riw"); 
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
            
            //need get translaation if its a source and get trnslation if target????
            
          public ResultSet getTranslation(long id_1,long id_2){
                
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
            
            List<Long> ids = new ArrayList<Long>();
            //List<Long> src_ids = new ArrayList<Long>();
            //List<Long> targ_ids = new ArrayList<Long>();
            
            Map<Long, Long> translation_ids = new LinkedHashMap<Long, Long>();
            
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
                    translation_ids.put(source_id, target_id);
                    
                    //src_ids.add(source_id);
                    //targ_ids.add(target_id);
                    
                }
                
                
//                if(ids.get(0)==src_ids.get(0)){
//                    out.println(" !!source");
//                }
//                else{
//                    out.println(" !!target");
//                }
                
                //check if src_term or targ_term in translation table
                long key = (Long) translation_ids.keySet().toArray()[0];
                out.println(" THE KEY IS; " +key);
                
                if(ids.get(0)==key){
                    out.println(" !!source");
                    //need to get targets
                    for(Map.Entry<Long, Long> entry: translation_ids.entrySet())
                    {
                        out.println("key is :" + entry.getKey() + "value is :" + entry.getValue());
                        rs_trans = t.getTranslation(entry.getKey(), entry.getValue());
                       
//                        while(rs_trans.next())
//                        {
//                            out.println("  in rs_trans"); 
//                            String term_1 = rs_trans.getString(1);
//                            String term_2 = rs_trans.getString(2);
//
//                            out.println(" term 1 is : "+term_1);
//                            out.println(" term 2 is : "+term_2);
//
//                        }
                    }
                }
                else{
                    out.println(" !!target");
                    // need to get source
                    for(Map.Entry<Long, Long> entry: translation_ids.entrySet())
                    {
                        out.println("key is :" + entry.getKey() + "value is :" + entry.getValue());
                        rs_trans = t.getTranslation(entry.getValue(),entry.getKey());
                       
//                        while(rs_trans.next())
//                        {
//                            out.println("  in rs_trans"); 
//                            String term_1 = rs_trans.getString(1);
//                            String term_2 = rs_trans.getString(2);
//
//                            out.println(" term 1 is : "+term_1);
//                            out.println(" term 2 is : "+term_2);
//
//                        }
                    }
                }

                //rs_trans = t.getTranslation(source_id,target_id);
                
                

                while(rs_trans.next()){
                    out.println("  in rs_trans"); 
                    String term_1 = rs_trans.getString(1);
                    String term_2 = rs_trans.getString(2);

                    out.println(" term 1 is : "+term_1);
                    out.println(" term 2 is : "+term_2);

                }
            }
            
//            if(source_id==id)
//            {
//                //want the target
//                rs_trans = t.getTranslation(source_id,target_id);
//                out.println(" source | translates to:" +target_id);
//                
//                
//                while(rs_trans.next())
//                {
//                    String a = rs_trans.getString("term");
//                    out.println(" term a :" +a);
//                }
//                
//                
//            }
//            else{
//                out.println(" target | translates to:" +source_id);
//            }
            
            %>
            <table border="1">
            <tbody>
                <tr>
                    <td>Translation</td>
                </tr>
               <% while (rs_trans.next()) {%>
                <tr>
                    <td><%= rs_trans.getString(1)%></td>               
                </tr>
                <% } %>
            </tbody>
        </table>
                   
    </body>
</html>
