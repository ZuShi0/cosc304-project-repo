<!DOCTYPE html>
<html>
<head>
<title>Limit DNE - Account Info</title>
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
			out.println("<li><a class=\"active\" href=\"customer.jsp\">Account Info: "
				+user+"</a></li>");
				out.println("<li><a class=\"inactive\" href=\"admin.jsp\">Admin Portal</a></li>");
				out.println("<li><a class=\"inactive\" href=\"logout.jsp\">Logout</a></li>");
			}
			else{
				out.println("<li><a class=\"inactive\" href=\"login.jsp\">Login</a></li>");
				out.println("<li><a class=\"active\" href=\"customer.jsp\">Account Info</a></li>");
			
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

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%
if (userName != null){

	getConnection();

	// TODO: Print Customer information
	String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, password"
				+ " FROM customer"
				+ " WHERE userId = ?";

	PreparedStatement pstmt = con.prepareStatement(sql);

	String newAddress = request.getParameter("newAddress");

	String newPassword = request.getParameter("newPassword");

	if(!(newAddress == null || newAddress == "")){

		String editcid = request.getParameter("editcid");
		String updateSql = "UPDATE customer"
					+ " SET address = ?"
					+ " WHERE customerId = ?";

		PreparedStatement Epstmt = con.prepareStatement(updateSql);
	
		Epstmt.setString(1, newAddress);
		Epstmt.setString(2, editcid);
		Epstmt.executeUpdate();

	}	

    Boolean validated = true;
	if(!(newPassword == null || newPassword == "")){

		
		if(!(newPassword.contains("!") || newPassword.contains("@") || newPassword.contains("#") || newPassword.contains(".") || newPassword.contains(",") || newPassword.contains("$") || newPassword.contains("%")
		|| newPassword.contains("^") || newPassword.contains("&") || newPassword.contains("*") || newPassword.contains("(") || newPassword.contains(")"))){
			validated = false;

		}
		if(newPassword.length() < 7){validated = false; }

		if(validated == true){
			String editcid = request.getParameter("editcid");
			String updateSql = "UPDATE customer"
						+ " SET password = ?"
						+ " WHERE customerId = ?";

			PreparedStatement Epstmt = con.prepareStatement(updateSql);
		
			Epstmt.setString(1, newPassword);
			Epstmt.setString(2, editcid);
			Epstmt.executeUpdate();
		} else {
			validated = false;
		}

	}
	pstmt.setString(1, userName);
	ResultSet rst = pstmt.executeQuery();
	rst.next();
	

	int cid = rst.getInt(1);
	String firstName = rst.getString(2);
	String lastName = rst.getString(3);
	String email = rst.getString(4);
	String phonenum = rst.getString(5);
	String address = rst.getString(6);
	String city = rst.getString(7);
	String state = rst.getString(8);
	String postalCode = rst.getString(9);
	String country = rst.getString(10);
	String password = rst.getString(11);

	out.println("<table><tr><th>Id</th><td>" + cid + "</td></tr>");
	out.println("<tr><th>First Name</th><td>" + firstName + "</td></tr>");
	out.println("<tr><th>Last Name</th><td>" + lastName + "</td></tr>");
	out.println("<tr><th>Email</th><td>" + email + "</td></tr>");
	out.println("<tr><th>Phone</th><td>" + phonenum + "</td></tr>");
	out.println("<tr><th>Address</th><td>" + address + "</td></tr>");
	out.println("<tr><th>City</th><td>" + city + "</td></tr>");
	out.println("<tr><th>State</th><td>" + state + "</td></tr>");
	out.println("<tr><th>Postal Code</th><td>" + postalCode + "</td></tr>");
	out.println("<tr><th>Country</th><td>" + country + "</td></tr>");
	out.println("<tr><th>User Id</th><td>" + userName + "</td></tr>");
	out.println("</table>");
	out.println("<br>");
	out.println("<table><tr><th>Edit Information</th><th></th></tr>");
	out.println("<tr><th colspan=\"2\" align=\"left\">Edit Address</th></tr>");	
	out.println("<form method=\"get\" action=\"customer.jsp\">");
	out.println("<input type =\"hidden\" name=\"editcid\" value = \""+ cid +"\">");
	out.println("<tr><td><input type=\"text\" name=\"newAddress\" value= \""+ address +"\" size=\"50\"></td>");	
	out.println("<td><input type= \"submit\" value=\"Update Address\"></td></tr>");
	out.println("</form>");

	out.println("<tr><th colspan=\"2\" align=\"left\">Edit Password</th></tr>");	
	out.println("<form method=\"get\" action=\"customer.jsp\">");
	out.println("<input type =\"hidden\" name=\"editcid\" value = \""+ cid +"\">");
	out.println("<tr><td><input type=\"text\" name=\"newPassword\" value= \""+ password +"\" size=\"50\"></td>");	
	out.println("<td><input type= \"submit\" value=\"Update Password\"></td></tr>");
	out.println("</form></table>");

	if(!validated){
		out.println("Invalid password. Password must be larger than 6 characters and have a special character");
	}

	// Make sure to close connection
	closeConnection();
	}
%>

</body>
</html>

