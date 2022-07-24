<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Limit DNE - Order List</title>
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
		<li><a class="inactive" href="listprod.jsp">Products</a></li>
		<li><a class="active" href="listorder.jsp">Orders</a></li>
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
<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);
//out.println(currFormat.format(5.0));  // Prints $5.00

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

// Make connection

try ( Connection con = DriverManager.getConnection(url, uid, pw);
      Statement stmt = con.createStatement();) 
{	
	String SQL = "SELECT orderId, orderDate, customer.customerId, firstName, lastName, totalAmount"
				+ " FROM ordersummary INNER JOIN customer ON (ordersummary.customerId = customer.customerId)";	
	ResultSet rst = stmt.executeQuery(SQL);		
	out.println("<table>"
					+"<tr>"
						+"<th>OrderId</th>"
						+"<th>Order Date</th>"
						+"<th>Customer Id</th>"
						+"<th>Customer Name</th>"
						+"<th>Total Amount</th>"
					+"</tr>");
	while (rst.next())
	{	
		out.println("<tr><td>"+rst.getInt(1)+"</td>");
		out.println("<td>"+rst.getString(2)+"</td>");
		out.println("<td>"+rst.getInt(3)+"</td>");
		out.println("<td>"+rst.getString(4) + " " + rst.getString(5) + "</td>");
		out.println("<td>"+ currFormat.format(rst.getFloat(6))+"</td></tr>");

			String pSQL = "SELECT productId, quantity, price"
						+ " FROM orderproduct"
						+ " WHERE orderId = ?";
			PreparedStatement pstmt = con.prepareStatement(pSQL);
			pstmt.setInt(1, rst.getInt(1));
			ResultSet prst = pstmt.executeQuery();

		out.println("<tr align=\"right\"><td colspan= \"5\"><table>");
		out.println("<tr>"
						+"<th>Product Id</th>"
						+"<th>Quantity</th>"
						+"<th>Price</th>"
					+"</tr>");
				while (prst.next())
				{
					out.println("<tr><td>"+ prst.getInt(1) + "</td>");
					out.println("<td>"+ prst.getInt(2) + "</td>");
					out.println("<td>"+ currFormat.format(prst.getFloat(3)) + "</td></tr>");
				}
		out.println("</table></td></tr>");
	}
	out.println("</table>");
}
	catch (SQLException ex) { 	
		out.println(ex); 
}

// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection
%>

</body>
</html>

