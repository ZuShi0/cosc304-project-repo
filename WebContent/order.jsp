<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Limit DNE - Order Processing</title>
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
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
} 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

boolean validate = true;
int custInt = 0;
// Determine if valid customer id was entered
try {
	custInt = Integer.parseInt(custId);
	validate = true;
} catch (NumberFormatException e){
	validate = false;
}
// Determine if there are products in the shopping cart
if (productList == null || productList.size() <= 0 ){
	validate = false;
}
// If either are not true, display an error message
if (validate == false || custInt == 0){
	out.println("<br>");
	out.println("<br>");
	out.println("<h2>Invalid ID or Empty Cart</h2>");
	

}
else{
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

// Make connection
try (Connection con = DriverManager.getConnection(url, uid, pw);)
{
	//Stage 2 Customer ID Validation
	String sqlValid = "SELECT customerId FROM customer";
	PreparedStatement pstmtValid = con.prepareStatement(sqlValid);
	ResultSet rstValid = pstmtValid.executeQuery();
	validate = false;
	while (rstValid.next()){
		int dbCustId = rstValid.getInt(1);
		if (dbCustId == custInt){
			validate = true;
			break;
		}	
	}
	if (validate != true){
		out.println("<br>");
		out.println("<br>");
		out.println("<h2>Customer ID does not Exist!</h2>");
	}
	
	//Preparing Data for entry
	double orderTot = 0.0;
	long millis = System.currentTimeMillis();
	java.sql.Date orderDate = new java.sql.Date(millis);
	
	//Save order info to database
	String sql = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, ?, ?)";
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	pstmt.setString(1, custId);
	pstmt.setString(2, orderDate.toString());
	pstmt.setDouble(3, orderTot);
	pstmt.executeUpdate();
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);

	NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);
	out.println("<h2>Thank you for your purchase!</h2>");
	out.println("<h3>Customer No."+custId+"'s Order Summary</h3>");
	out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th></tr>");
	
	//Insert items into OrderProduct
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		while (iterator.hasNext())
		{
			String sqlOP = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)"; 
			PreparedStatement pstmtOP = con.prepareStatement(sqlOP);
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			String productId = (String) product.get(0);
			String productName = (String) product.get(1);
			String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			int qty = ( (Integer)product.get(3)).intValue();
			pstmtOP.setInt(1, orderId);
			pstmtOP.setString(2, productId);
			pstmtOP.setDouble(4, pr);
			pstmtOP.setInt(3, qty);
			pstmtOP.executeUpdate();

			out.print("<tr><td>"+productId+"</td>");
			out.print("<td>"+productName+"</td>");
			out.print("<td align=\"center\">"+qty+"</td>");
			out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
			out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td></tr>");
			out.println("</tr>");
			orderTot = orderTot+(pr*qty);
		}
		out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
		+"<td align=\"right\">"+currFormat.format(orderTot)+"</td></tr>");
		out.println("</table>");
		
		//Update Order total in ordersummary
		String sqlUP = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
		PreparedStatement pstmtUP = con.prepareStatement(sqlUP);
		pstmtUP.setDouble(1, orderTot);
		pstmtUP.setInt(2, orderId);
		pstmtUP.executeUpdate();

		//Clear Cart
		session.removeAttribute("productList");

}

catch (SQLException ex) { 	
	out.println(ex); 
}

}
// Clear cart if order placed successfully

%>
</BODY>
</HTML>

