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
<title>Limit DNE - Insert Product</title>
</head>
<body>

<%

String prodName = request.getParameter("productName");
String price = request.getParameter("productPrice");
String imgUrl = request.getParameter("productImageUrl");
String prodDesc = request.getParameter("productDesc");
String category = request.getParameter("categoryName");

try {

getConnection();


String insertSQL = "INSERT product (productName, categoryId, productDesc, productPrice, productImageUrl)"
                + " VALUES (?,?,?,?,?)";
PreparedStatement pstmt = con.prepareStatement(insertSQL);
pstmt.setString(1, prodName);
pstmt.setString(2, category);
pstmt.setString(3, prodDesc);
pstmt.setString(4, price);
pstmt.setString(5, imgUrl);
pstmt.executeUpdate();

out.println("Product successfully inserted!");
response.sendRedirect("admin.jsp");
closeConnection();

} catch (SQLException ex) { 	
	out.println(ex); 
}
%>


</body>
</html>