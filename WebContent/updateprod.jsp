<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.lang.Float" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Limit DNE - Update Product</title>
</head>
<style>
	table, th, td {
		border: 1px solid black;
		border-collapse: collapse;
		padding: 0.2em;
	}
</style>
<body>

<%

String prodId = "";
String prodName = null;
float prodPrice = 0;
String prodImgUrl = "";
String prodDesc = "";

if (request.getParameter("id") != null){
    prodId = request.getParameter("id");
}
if (request.getParameter("productName") != null){
    prodName = request.getParameter("productName");
}
if (request.getParameter("productPrice") != null && !request.getParameter("productPrice").isEmpty()) {
    String prodPriceString = request.getParameter("productPrice");
    prodPrice = Float.parseFloat(prodPriceString);
}
if (request.getParameter("productImageURL") != null){
    prodImgUrl = request.getParameter("productImageURL");
}
if (request.getParameter("productDesc") != null){
    prodDesc = request.getParameter("productDesc");
}

String cid = request.getParameter("categoryId");




NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);


try {

getConnection();

String prodValuesSQL = "SELECT productName, productPrice, productImageURL, productDesc, categoryId"
                    + " FROM product"
                    + " WHERE productId = ?";
PreparedStatement pstmt = con.prepareStatement(prodValuesSQL);
pstmt.setString(1, prodId);
ResultSet currentRST = pstmt.executeQuery();
currentRST.next();

String currentName = currentRST.getString(1);
float currentPrice = currentRST.getFloat(2);
String currentImgUrl = currentRST.getString(3);
String currentDesc = currentRST.getString(4);
String currentCategory = currentRST.getString(5);

out.println("<form method=\"post\" action=\"updateprod.jsp\">");
out.println("<table><tr><th>Columns</th><th>Current</th><th>New</th></tr>");
out.println("<tr><th>Product Id</th><td>" + prodId + "</td><td><input type=\"text\" name=\"id\" value=\"" + prodId + "\"readonly></td></tr>");
out.println("<tr><th>Product Name</th><td>" + currentName + "</td><td><input type=\"text\" name=\"productName\" value=\""+currentName+"\"></td></tr>");
out.println("<tr><th>Product Price</th><td>" + currFormat.format(currentPrice) + "</td><td><input type=\"text\" name=\"productPrice\" value=\""+currentPrice+"\"></td></tr>");
out.println("<tr><th>Product Image Url</th><td>" + currentImgUrl + "</td><td><input type=\"text\" name=\"productImageURL\" value=\""+currentImgUrl+"\"></td></tr>");
out.println("<tr><th>Product Description</th><td>" + currentDesc + "</td><td><input type=\"text\" name=\"productDesc\" value=\""+currentDesc+"\"></td></tr>");
out.println("<tr><th>Category Id</th><td>" + currentCategory + "</td><td><select name=\"categoryId\">"
	+ "<option value=\"1\">Consoles 1</option>"
	+ "<option value=\"2\">Clothing 2</option>"
	+ "<option value=\"3\">PC Hardware 3</option>"
	+ "<option value=\"4\">Groceries 4</option>"
    + "</select></td></tr>");
out.println("</table>");
out.println("<input type=\"submit\" value=\"Submit\"><input type=\"reset\" value=\"Reset\"></form>");


if (prodName != null){
    String updateSQL = "UPDATE product"
                    + " SET productName = ?, productPrice = ?, productImageURL = ?, productDesc = ?, categoryId = ?"
                    + " WHERE productId = ?";
    pstmt = con.prepareStatement(updateSQL);
    pstmt.setString(1, prodName);
    pstmt.setFloat(2, prodPrice);
    pstmt.setString(3, prodImgUrl);
    pstmt.setString(4, prodDesc);
    pstmt.setString(5, cid);
    pstmt.setString(6, prodId);
    pstmt.executeUpdate();

out.println("Product successfully updated!");
response.sendRedirect("updateProd.jsp?id=" + prodId);
}

closeConnection();



} catch (SQLException ex) { 	
	out.println(ex); 
}
%>

<h2><a href="admin.jsp">Return to admin page</a></h2>

</body>
</html>