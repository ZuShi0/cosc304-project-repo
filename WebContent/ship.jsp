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
<title>Limit DNE - Shipment Processing</title>
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
	// TODO: Get order id
	String orderId = request.getParameter("orderId");
	
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";

	try (Connection con = DriverManager.getConnection(url, uid, pw);){
		// TODO: Check if valid order id
		String validOrdId = "SELECT orderId FROM ordersummary WHERE orderId = ?";
		PreparedStatement pstmt = con.prepareStatement(validOrdId);
		pstmt.setString(1, orderId);
		ResultSet rst = pstmt.executeQuery();
		rst.next();
		int oId = rst.getInt(1);
		String oIds = String.valueOf(oId);
		if (!orderId.equals(oIds)){
			out.println("<h3> Error with orderId</h3>");
			closeConnection();
		}
			// TODO: Start a transaction (turn-off auto-commit)
		con.setAutoCommit(false);

	
		// TODO: Retrieve all items in order with given id
		String ordP = "SELECT productId, quantity FROM orderproduct WHERE orderId = ?";
				pstmt = con.prepareStatement(ordP);
				pstmt.setString(1, orderId);
				ResultSet rstOrd = pstmt.executeQuery();

		// TODO: Create a new shipment record.
		long millis = System.currentTimeMillis();
		java.sql.Date shippedDate = new java.sql.Date(millis);	
		String newShip = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId)"
					+ " VALUES (?, 'Shipped', 1)";
					pstmt = con.prepareStatement(newShip);
					pstmt.setString(1, shippedDate.toString());
					pstmt.executeUpdate();
		// TODO: For each item verify sufficient quantity available in warehouse 1.
		StringBuilder errorMessage = new StringBuilder();
		while (rstOrd.next()){
			int productId = rstOrd.getInt(1);
			int ordQuantity = rstOrd.getInt(2);
	
			String checkInv = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1";
			pstmt = con.prepareStatement(checkInv);
			pstmt.setInt(1, productId);
			ResultSet rstInv = pstmt.executeQuery();
	
			rstInv.next();
			int inv = rstInv.getInt(1);
			out.println("<h2>Ordering Product: " + productId + " Quantity Buying: " + ordQuantity + " Current Stock: "+inv+" New Stock: "+(inv-ordQuantity)+"</h2>");
			if (inv-ordQuantity < 0){
				String emPart = "Insufficient Inventory for ProductId: " + rstOrd.getString(1)+" | ";
				errorMessage.append(emPart);
			}
			else{
				String invUpdate = "UPDATE productinventory SET quantity = quantity-1 WHERE productId = ? AND warehouseId = 1";
				pstmt = con.prepareStatement(invUpdate);
				pstmt.setInt(1, productId);
				pstmt.executeUpdate();
			}
				
		}
		// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
		if (errorMessage.toString().contains("Insufficient Inventory")){
			out.println("<h2>"+errorMessage.toString()+"</h2>");
			con.rollback();
		}
		else{
			out.println("<h2>Shipment Successful! Order Placed.</h2>");
			con.commit();
		}
		// TODO: Auto-commit should be turned back on
		con.setAutoCommit(true);
	}
	catch (SQLException ex){
		out.println("SQLException: " + ex); 
		//con.rollback();
	}
%>                       				
</body>
</html>
