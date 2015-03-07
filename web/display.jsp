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
            
            
            public long getTermID(String term, int src_lang_id){
                long x=0;
                try{
                  //con = DriverManager.getConnection("jdbc:mysql://danu6.it.nuigalway.ie:3306/mydb1803","mydb1803gk","ki1riw"); 
                    pst = con.prepareStatement("Select id from terms where term like ? and language_id= ?");
                    pst.setString(1, term);
                    pst.setInt(2, src_lang_id);
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
            
            public ResultSet getTranslationID(long src_term_id){
                
                try{
                    pst = con.prepareStatement("Select targ_term_id from translations where src_term_id = ?");
                    pst.setLong(1, src_term_id);
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
            int src_lang=0;
            
            if(request.getParameter("source_term") != null){
                src_term = request.getParameter("source_term");
            }
            
            if(request.getParameter("source_language") != null){
                src_lang =  Integer.parseInt(request.getParameter("source_language"));
            }

            out.println("Source term is " +src_term);
            out.println("\nSource language id is " +src_lang);
            Translate t = new Translate();
            long id = t.getTermID(src_term, src_lang);
            out.println("\nid is " +id);
            ResultSet rs_trans_ids = t.getTranslationID(id);
            
//            while(rs_trans_ids.next())
//            {
//                long trans_ids = rs_trans_ids.getLong("targ_term_id");
//                out.println("\ntrans_ids " +trans_ids);
//            }
            %>
            <table border="1">
            <tbody>
                <tr>
                    <td>Translation</td>
                </tr>
               <% while (rs_trans_ids.next()) {%>
                <tr>
                    <td><%= rs_trans_ids.getInt("targ_term_id")%></td>
                </tr>
                <% } %>
            </tbody>
        </table>
            
            
            
        
 

        
    </body>
</html>
