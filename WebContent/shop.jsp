<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
        <title>Limit DNE - Home Page</title>
</head>
<style>
	table, th, td {
		  border: 1px solid black;
		  border-collapse: collapse;
		padding: 0.2em;
		margin: auto;
	}

	td.first {
		border: 1px solid black;
        padding: 10px;
        box-shadow:
        inset 0 0 50px #fff,     
        inset 20px 0 20px #ff0,   
        inset -20px 0 20px goldenrod,  
        inset 20px 0 300px #ff0,  
        inset -20px 0 300px goldenrod, 
        0 0 50px #fff,           
        -10px 0 20px #ff0,       
        10px 0 20px goldenrod;
	}

	td.second {
		border: 1px solid black;
        padding: 10px;
        box-shadow:
        inset 0 0 50px #fff,     
        inset 20px 0 20px silver,   
        inset -20px 0 20px grey,  
        inset 20px 0 300px silver,  
        inset -20px 0 300px grey, 
        0 0 50px #fff,           
        -10px 0 20px silver,       
        10px 0 20px grey;
	}

	td.third {
		border: 1px solid black;
        padding: 10px;
        box-shadow:
        inset 0 0 50px #fff,     
        inset 20px 0 20px burlywood,   
        inset -20px 0 20px brown,  
        inset 20px 0 300px burlywood,  
        inset -20px 0 300px brown, 
        0 0 50px #fff,           
        -10px 0 20px burlywood,       
        10px 0 20px brown;
	}

	ul {
		position: fixed;
		top: 0;
		width: 100%;
		list-style-type: none;
  		margin: 0;
  		padding: 0;
  		overflow: hidden;
  		background-color: #333;
	}
	
        li {
                float:left;
        }

	li a {
  		display: block;
  		color: white;
  		text-align: center;
  		padding: 14px 16px;
  		text-decoration: none;
	}

	li a:hover {
		background-color: #111;
	}

	.active {
		background-color: darkslateblue;
	}

	
	</style>
<body>
<ul>
<li><a class="active" href="shop.jsp">Home</a></li>
<li><a class="inactive" href="listprod.jsp">Products</a></li>
<li><a class="inactive" href="listorder.jsp">Orders</a></li>
<li><a class="inactive" href="checkout.jsp">Checkout</a></li>
<li><a class="inactive" href="showcart.jsp">Show Cart</a></li>
<li><a class="inactive" href="displaywares.jsp">Warehouse Info</a></li>
<%
if (session.getAttribute("authenticatedUser") != null) {
	String user = session.getAttribute("authenticatedUser").toString();
	out.println("<li><a class=\"inactive\" href=\"customer.jsp\">Logged In: "
		+user+"</a></li>");
		out.println("<li><a class=\"inactive\" href=\"admin.jsp\">Admin Portal</a></li>");
		out.println("<li><a class=\"inactive\" href=\"logout.jsp\">Logout</a></li>");
	}
	else{
		out.println("<li><a class=\"inactive\" href=\"login.jsp\">Login</a></li>");
		out.println("<li><a class=\"inactive\" href=\"customer.jsp\">Account Info</a></li>");
	
	}
%>
<%
if (session.getAttribute("dataLoaded") == null){
	out.println("<li><a class=\"inactive\" href=\"loaddata.jsp\">Load Data</a></li>");
}
%>
</ul>
<br>
<br>
<h1 align="center">Welcome to Limit DNE</h1>
<h2 align="center"><a href="about.jsp">About Us</a></h2>
<br>

<div id="topselling">
<%
if (session.getAttribute("dataLoaded") != null){
	out.println("<h2 align=\"center\">Top Selling Products</h2>");
getConnection();

String topSellSQL = "Select TOP (3) productId, SUM(quantity)"
				+ " FROM orderproduct"
				+ " GROUP BY productId"
				+ " ORDER BY SUM(quantity) DESC";
PreparedStatement pstmt = con.prepareStatement(topSellSQL);
ResultSet topRST = pstmt.executeQuery();
int i = 1;
out.println("<table><tr>");

while (topRST.next()){
if (i == 1){
	out.println("<td class=\"first\">");
}
else if (i==2){
	out.println("<td class=\"second\">");
}
else{
	out.println("<td class=\"third\">");
}
String productId = topRST.getString(1);
String sql = "SELECT productName, productPrice, productImageURL, productDesc FROM product WHERE productId = ?";
pstmt = con.prepareStatement(sql);
pstmt.setString(1, productId);
ResultSet rst = pstmt.executeQuery();
rst.next();
String pname = rst.getString(1);
float pprice = rst.getFloat(2);
String url = rst.getString(3);
String desc = rst.getString(4);
NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

String addLink = "addcart.jsp?id=" + productId + "&name="
				+""+ pname + "&price=" + pprice + "&imgLink=" + url;

out.println("<table><tr><th>Product Info</th><th>Product Name: "+pname
	+"</th><th>Product Number: "
	+productId+"</th></tr>");
// TODO: If there is a productImageURL, display using IMG tag
out.println("<tr><td colspan=\"3\"><img src="+"\""+url+"\""+"style=\"width:450px;height:400px;\"></td></tr>");
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
//String imgLink = "displayImage.jsp?id="+productId;
//out.println("<img src="+"\""+imgLink+"\""+">");
out.println("<tr><td><b>Price: "+currFormat.format(pprice)
	+"</b></td><td style=\"text-align: center; vertical-align: middle; font-size: 35px\" "
	+"colspan=\"2\" rowspan=\"2\"><a href=\"listprod.jsp?productName=\""
	+"><b>Continue Shopping</b></a></td></tr>");
// TODO: Add links to Add to Cart and Continue Shopping
out.println("<tr><td><a href=" + "\"" + addLink + "\"" 
	+"><b>Add to Cart</b></a></td></tr>"
	+"<tr><td colspan=\"3\"><b>Description:</b> " + desc +"</td></tr></div>"
	+"<tr><td colspan=\"3\"><b>Total Sold:</b> " + topRST.getInt(2)
	+"</td></tr></div></table>");

out.println("</td>");
i++;
}

out.println("</tr></table>");
}
// TODO: Display user name that is logged in (or nothing if not logged in)

        if (session.getAttribute("authenticatedUser") != null) {
        String user = session.getAttribute("authenticatedUser").toString();
        out.println("<h3 align=\"center\">Signed in as: " + user + "</h3>");
        }
%>

</div>
</body>
</head>


