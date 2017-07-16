<%@ page pageEncoding="GB18030"%>
<%@ page import="java.sql.*, com.bjsxt.bbs.*, java.util.*"%>

<%@ include file="_SessionCheck.jsp" %>

<%!
private void delete(Connection conn, int id, boolean isLeaf) {
	//delete all the children
	//delete(conn, chids's id)
	
	if(!isLeaf) { 
		String sql = "select * from article where pid = " + id;
		Statement stmt = DB.creatStatement(conn);
		ResultSet rs = DB.executeQuery(stmt, sql); 
		try {
			while(rs.next()) {
				delete(conn, rs.getInt("id"), rs.getInt("isleaf") == 0);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.Close(rs);
			DB.Close(stmt);
		}
	}
	
	
	//delete self
	DB.executeUpdate(conn, "delete from article where id = " + id);
	
	
}
%>

<%
int id = Integer.parseInt(request.getParameter("id"));
int pid = Integer.parseInt(request.getParameter("pid"));
boolean isLeaf = Boolean.parseBoolean(request.getParameter("isLeaf"));
//String url = request.getParameter("from");
//System.out.println("url = " + url);
Connection conn = null;
boolean autoCommit = true;
Statement stmt = null;
ResultSet rs = null;

try {
	conn = DB.getConnection();
	autoCommit = conn.getAutoCommit();
	conn.setAutoCommit(false);
	
	delete(conn, id, isLeaf);
	
	stmt = DB.creatStatement(conn);
	rs = DB.executeQuery(stmt, "select count(*) from article where pid = " + pid);
	rs.next();
	int count = rs.getInt(1);
	
	if(count <= 0) {
		DB.executeUpdate(conn, "update article set isleaf = 0 where id = " + pid);
	}
	
	conn.commit();
} catch(Throwable e){  
           if(conn!=null){  
               try {  
                   conn.rollback();  
               } catch (SQLException e1) {  
                   e1.printStackTrace();  
               }  
           }  
throw new RuntimeException(e);
}finally {
	conn.setAutoCommit(autoCommit);
	DB.Close(rs);
	DB.Close(stmt);
	DB.Close(conn);
}
response.sendRedirect("articleFlat.jsp");
%>

