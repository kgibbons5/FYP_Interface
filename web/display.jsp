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
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
            }
            
            
            public long getTermID(long src_lang_id,String term){
                long x=0;
                try{
                  //con = DriverManager.getConnection("jdbc:mysql://danu6.it.nuigalway.ie:3306/mydb1803","mydb1803gk","ki1riw"); 
                    pst = con.prepareStatement("Select id from terms where language_id= ? and term like ?");
                    pst.setLong(1, src_lang_id);
                    pst.setString(2, term);
                    
                    rs = pst.executeQuery();
                    
                    while(rs.next()){
                        x=(long)rs.getInt(1);
                    }
                    
                    
                    
                }
                catch(SQLException e){
                    e.printStackTrace();
                }
                return x;
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
                    pst = con.prepareStatement("Select * from terms where id = ? or id= ?");
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
            long id = t.getTermID(src_lang,src_term);
            out.println("Id is " +id);
            out.println("Target language id is " +targ_lang);
            ResultSet rs_trans_ids = t.getTranslationID(id,targ_lang);
            ResultSet rs_trans=null;
            
 
            while(rs_trans_ids.next())
            {
                source_id = rs_trans_ids.getLong("src_term_id");
                target_id = rs_trans_ids.getLong("targ_term_id");
                out.println("    source_id is "+source_id);
                out.println("    target_id is "+target_id);
            }
            rs_trans = t.getTranslation(source_id,target_id);
            
            if(!rs_trans.next()){
                out.println(" no data in rs_trans");  
            }
            
            while(rs_trans.next()){
                String term = rs_trans.getString("term");
                
                
                
                out.println("    term is "+term);
                
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
                    <td><%= rs_trans.getString("term")%></td>               
                </tr>
                <% } %>
            </tbody>
        </table>
            
            
            
        
 

        
    </body>
</html>
