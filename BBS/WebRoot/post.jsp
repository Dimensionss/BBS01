<%@page pageEncoding="GB18030" %>
<%@page import="java.sql.*,com.bjsxt.bbs.*" %>

<%
request.setCharacterEncoding("GBK");
String action = request.getParameter("action");
if(action != null && action.trim().equals("post")){
       String title = request.getParameter("title");
String cont = request.getParameter("cont");

Connection conn = DB.getConnection();

boolean autoCommit = conn.getAutoCommit();
conn.setAutoCommit(false);

int rootId=-1;

String sql = "insert into Article values(null,?,?,?,?,now(),?)";
PreparedStatement pstmt = DB.prepareStatement(conn, sql,Statement.RETURN_GENERATED_KEYS);
pstmt.setInt(1, 0);
pstmt.setInt(2, 0);
pstmt.setString(3, title);
pstmt.setString(4, cont);
pstmt.setInt(5, 0);
pstmt.executeUpdate();

ResultSet rsKey = pstmt.getGeneratedKeys();
rsKey.next();
rootId = rsKey.getInt(1);

Statement stmt = DB.creatStatement(conn);
stmt.executeUpdate("update article set rootid =" + rootId +" where id =" +rootId);

conn.commit();
conn.setAutoCommit(autoCommit);

DB.Close(pstmt);
DB.Close(conn);

response.sendRedirect("article.jsp");
}
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>发表新主题</title>
<meta http-equiv="content-type" content="text/html; charset=GBK">
<link rel="stylesheet" type="text/css" href="images/style.css" title="Integrated Styles">
<script language="JavaScript" type="text/javascript" src="images/global.js"></script>
<link rel="alternate" type="application/rss+xml" title="RSS" href="http://bbs.chinajavaworld.com/rss/rssmessages.jspa?threadID=744236">
</head>
<body>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tbody>
    <tr>
      <td width="140"><a href="http://bbs.chinajavaworld.com/index.jspa"><img src="images/header-left.gif" alt="Java|Java世界_中文论坛|ChinaJavaWorld技术论坛" border="0"></a></td>
      <td><img src="images/header-stretch.gif" alt="" border="0" height="57" width="100%"></td>
      <td width="1%"><img src="images/header-right.gif" alt="" border="0"></td>
    </tr>
  </tbody>
</table>
<br>
<div id="jive-flatpage">
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
      <tr valign="top">
        <td width="99%"><div id="jive-message-holder">
            <div class="jive-message-list">
              <div class="jive-table">
                <div class="jive-messagebox">
                 
                   <form action="post.jsp" method="post">
                      <input type="hidden" name="action" value="post"/> 
                      <input type="text" name="title"><br>
                      <textarea name="cont" rows="15" cols="80"></textarea>
                      <br>
                      <input type="submit" value="提交"/>
                   </form>
                 
                </div>
              </div>
            </div>
            <div class="jive-message-list-footer">
              <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tbody>
                  <tr>
                    <td nowrap="nowrap" width="1%"></td>
                    <td align="center" width="98%"><table border="0" cellpadding="0" cellspacing="0">
                        <tbody>
                          <tr>
                            <td><a href="http://bbs.chinajavaworld.com/forum.jspa?forumID=20"><img src="images/arrow-left-16x16.gif" alt="返回到主题列表" border="0" height="16" hspace="6" width="16"></a> </td>
                            <td><a href="http://bbs.chinajavaworld.com/forum.jspa?forumID=20">返回到主题列表</a> </td>
                          </tr>
                        </tbody>
                      </table></td>
                    <td nowrap="nowrap" width="1%">&nbsp;</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div></td>
        <td width="1%"></td>
      </tr>
    </tbody>
  </table>
</div>
</body>
</html>
