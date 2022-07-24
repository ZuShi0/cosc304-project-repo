<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Limit DNE - Product Information</title>
</head>
<style>
	table, th, td {
		  border: 1px solid black;
		  border-collapse: collapse;
		padding: 0.2em;
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
		<li><a class="inactive" href="shop.jsp">Home</a></li>
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

<%
// Get product name to search for
// TODO: Retrieve and display info for the product
getConnection();
String productId = request.getParameter("id");
String sql = "SELECT productName, productPrice, productImageURL, productDesc FROM product WHERE productId = ?";
PreparedStatement pstmt = con.prepareStatement(sql);
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
	+"<tr><td colspan=\"3\"><b>Description:</b> "+desc+"</td></tr>"
	+"<tr><td><b>Leave a Review</b></td><td colspan=\"2\" style=\"text-align: center; vertical-align: middle;\">"
	+"<form method=\"get\" action=\"addreview.jsp\">"
	+"<textarea name=\"reviewComment\" rows=\"4\""
	+" cols=\"50\" maxlength=\"1000\"></textarea><br>"
	+"<b><label>Rating</label></b>"
	+"<select name=\"reviewRating\">"
	+"<option value=\"1\">1</option>"
	+"<option value=\"2\">2</option>"
	+"<option value=\"3\">3</option>"
	+"<option value=\"4\">4</option>"
	+"<option value=\"5\">5</option>"
	+"</select>"
	+"<b><label>Customer Id</label></b>"
	+"<input type=\"text\" name=\"customerId\" size=\"2\" maxlength=\"3\">"
	+"<input type=\"hidden\" name=\"productId\" value=\""+productId+"\">"
	+"<input type=\"submit\" value=\"Submit\">"
	+"</form></td></tr></table>");

String reviewSql = "SELECT * FROM review WHERE productId = ? ORDER BY reviewId ASC";
pstmt = con.prepareStatement(reviewSql);
pstmt.setString(1, productId);
ResultSet revRst = pstmt.executeQuery();

out.println("<table><tr><th>Review Number</th><th>Customer Comment</th>"
+"<th>Customer Rating</th><th>Review Date</th></tr>");
while(revRst.next()){
	String rId = revRst.getString(1);
	String rRating = revRst.getString(2);
	String rDate = revRst.getString(3);
	String rComment = revRst.getString(6);
	out.println("<tr><td>"+rId+"</td><td>"+rComment+"</td><td>"+rRating
	+"</td><td>"+rDate+"</td></tr>");
}
out.println("</table>");
closeConnection();
%>

</body>
</html>

