<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Limit DNE - Products</title>
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
		float: left;
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
		<li><a class="active" href="listprod.jsp">Products</a></li>
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
<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<select name="categoryName">
	<option value="">All</option>
	<option value="Consoles">Consoles</option>
	<option value="Clothing">Clothing</option>
	<option value="PC Hardware">PC Hardware</option>
	<option value="Groceries">Groceries</option>
</select>
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<h1>View Products by Category: </h1>
<table>
	<tr>
		<th>Consoles</th>
		<th>Clothing</th>
		<th>PC Hardware</th>
		<th>Groceries</th>
	</tr>
	<tr>
		<td> 
			<a href="listprod.jsp?productName=&categoryName=Consoles">
				<img src="img/Consoles.jpg" style="width:150px;height:125px;">
			</a>
		</td>
		<td> 
			<a href="listprod.jsp?productName=&categoryName=Clothing">
				<img src="img/Clothing.jpg" style="width:150px;height:125px;">
			</a>
		</td>
		<td> 
			<a href="listprod.jsp?productName=&categoryName=PC Hardware">
				<img src="img/PCHardware.jpg" style="width:150px;height:125px;">
			</a>
		</td>
		<td> 
			<a href="listprod.jsp?productName=&categoryName=Groceries">
				<img src="img/Grocery.jpg" style="width:150px;height:125px;">
			</a>
		</td>
	</tr>
</table>
<% // Get product name to search for
String name = request.getParameter("productName");
String displayName = "";
if (name != null){
	displayName = name;
}
String catName = "";
if (request.getParameter("categoryName") != null){
	catName = request.getParameter("categoryName");
}
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
// Make the connection
try (Connection con = DriverManager.getConnection(url, uid, pw);)
{
	out.println("<h1>Products Related to: "+displayName+"</h1>");
	String SQL = "SELECT productName, productPrice, productId, categoryName, productImageURL "
				+"FROM product join category ON product.categoryId = category.categoryId "
				+"WHERE productName LIKE ? AND categoryName LIKE ?";
	PreparedStatement pstmt = con.prepareStatement(SQL);
	name = "%"+name+"%";
	catName = "%"+catName+"%"; 
	pstmt.setString(1, name);
	pstmt.setString(2, catName);
	ResultSet rst = pstmt.executeQuery();
	out.println("<table>"
		+"<tr>"
			+"<th></th>"
			+"<th>Product Name</th>"
			+"<th>Product Image</th>"
			+"<th>Category</th>"
			+"<th>Price</th>"
		+"</tr>");
	while (rst.next()) {
		String imageUrl = rst.getString(5);
		String addLink = "addcart.jsp?id=" + rst.getInt(3) + "&name="
						+""+ rst.getString(1) + "&price=" + rst.getFloat(2)
						+"&imgLink="+imageUrl;
		String detailLink = "product.jsp?id=" + rst.getInt(3);
		out.println("<tr><td><a href=" + "\"" + addLink + "\"" +">Add to Cart</a></td>");
		out.println("<td><a href=" + "\"" + detailLink + "\"" +">"+rst.getString(1)+"</a></td>");
		out.println("<td><a href=" + "\"" + detailLink + "\"" 
			+"><img src="+"\""+imageUrl+"\""+"style=\"width:100px;height:75px;"
			+"text-align:center;vertical-align:middle\"></a></td>");
		out.println("<td>"+rst.getString(4)+"</td>");
		out.println("<td>"+currFormat.format(rst.getFloat(2))+"</td></tr>");
	}
	out.println("</table>");
}
catch (SQLException ex) { 	
	out.println(ex); 
}
// Print out the ResultSet

// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>