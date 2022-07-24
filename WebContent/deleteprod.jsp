<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Limit DNE - Delete Product</title>
</head>
<body>

<%

String prodId = request.getParameter("id");


try {

getConnection();


String deleteSQL = "DELETE FROM product"
                + " WHERE productId = ?";
PreparedStatement pstmt = con.prepareStatement(deleteSQL);
pstmt.setString(1, prodId);
pstmt.executeUpdate();

out.println("Product successfully deleted!");

closeConnection();

response.sendRedirect("admin.jsp");

} catch (SQLException ex) { 	
	out.println(ex); 
}
%>


</body>
</html>