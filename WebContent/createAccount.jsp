<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Limit DNE - Account Creation</title>
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
	<h1>Creating customer account, please enter required information below:</h1>

	<form method="get" action="createAccount.jsp">
	<table>
	<tr>
		<th>Customer Info</th>
	</tr>
	
	<tr><td>
	<p></p>	
	<div align="left"><font face="Arial, Helvetica, sans-serif" size="2">First Name  :</font><input type="text" name="firstName" size="50"></div>
	<p></p>
	</td></tr>
	
	<tr><td>
	<p></p>	
	<div align="left"><font face="Arial, Helvetica, sans-serif" size="2">Last Name   :</font><input type="text" name="lastName" size="50"></div>
	<p></p>
	</td></tr>
	
	<tr><td>
	<p></p>
	<div align="left"><font face="Arial, Helvetica, sans-serif" size="2">Email       :</font><input type="text" name="email" size="50"></div>
	<p></p>
	</td></tr>
	
	<tr><td>
	<p></p>
	<div align="left"><font face="Arial, Helvetica, sans-serif" size="2">Phone Number:</font><input type="text" name="phonenum" size="50"></div>
	<p></p>
	</td></tr>
	
	<tr><td>
		<p></p>
	<div align="left"><font face="Arial, Helvetica, sans-serif" size="2">Address     :</font><input type="text" name="address" size="50"></div>
	<p></p>
	</td></tr>
	
	<tr><td>
	<p></p>
	<div align="left"><font face="Arial, Helvetica, sans-serif" size="2">City        :</font><input type="text" name="city" size="50"></div>
	<p></p>
	</td></tr>
	
	<tr><td>
	<p></p>
	<div align="left"><font face="Arial, Helvetica, sans-serif" size="2">State       :</font><input type="text" name="state" size="50"></div>
	<p></p>
	</td></tr>
	
	<tr><td>
	<p></p>
	<div align="left"><font face="Arial, Helvetica, sans-serif" size="2">Postal Code :</font><input type="text" name="postalCode" size="50"></div>
	<p></p>
	</td></tr>
	
	<tr><td>
	<p></p>
	<div align="left"><font face="Arial, Helvetica, sans-serif" size="2">Country     :</font><input type="text" name="country" size="50"></div>
	<p></p>
	</td></tr>
	
	<tr><td>
	<p></p>
	<div align="left"><font face="Arial, Helvetica, sans-serif" size="2">User ID     :</font><input type="text" name="userid" size="50" maxlength="20"></div>
	<p></p>
	</td></tr>
	
	<tr><td>
	<p></p>
	<div align="left"><font face="Arial, Helvetica, sans-serif" size="2">Password    :</font><input type="text" name="password" size="50" maxlength="30"></div>
	<div align="left"><font face="Arial, Helvetica, sans-serif" size="2"> Password must include a special character and be at least 6 characters long</div>
	
	<p></p>
	</td></tr>
	
	<tr><td>
	<input type="submit" value="Submit">
	</td></tr>
	</table>
	
	</form>
	
	
	<%@ include file="jdbc.jsp" %>
	
	<%
	
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = request.getParameter("email");
		String phonenum = request.getParameter("phonenum");
		String address = request.getParameter("address");
		String city = request.getParameter("city");
		String state = request.getParameter("state");
		String postalCode = request.getParameter("postalCode");
		String country = request.getParameter("country");
		String userid = request.getParameter("userid");
		String password = request.getParameter("password");
	
		
	if(!(firstName == null  && lastName == null && email == null && phonenum == null && address == null && city == null && state == null && postalCode == null && country == null
		&& userid == null && password == null)){
		
		Boolean validated = true;
	
		// regex didnt work so it's getting greasy
		if(!(password.contains("!") || password.contains("@") || password.contains("#") || password.contains(".") || password.contains(",") || password.contains("$") || password.contains("%")
		|| password.contains("^") || password.contains("&") || password.contains("*") || password.contains("(") || password.contains(")"))){
			validated = false;
			out.println("Password requires a special character");
		}
	
		if(password.length() < 7){validated = false; out.println("Invalid password. Password must be larger than 6 characters");}
		if(!email.contains("@")){validated = false; out.println("Invalid email. Must contain @ character");}
		if(firstName.length()>30){validated = false; out.println("First Name must be less than 30 characters long");}
		if(lastName.length() >30){validated = false; out.println("Last Name must be less than 30 characters long");}
		if(address.length() >30){validated = false; out.println("Address must be less than 30 characters long");}
		if(city.length() >30){validated = false; out.println("City must be less than 30 characters long");}
		if(state.length() >30){validated = false; out.println("State must be less than 30 characters long");}
		if(country.length() >30){validated = false; out.println("Country must be less than 30 characters long");}
		if(userid.length() >20){validated = false; out.println("Username must be less than 10 characters long");}
	
		if(validated==true){
	
			getConnection();
	
			//Check if userID is already present in customer.jsp
			String sqlCheck = "SELECT userid FROM customer";
			Statement stmtCheck = con.createStatement();
			ResultSet rstCheck = stmtCheck.executeQuery(sqlCheck);
			Boolean isSame = false;
	
			while(rstCheck.next()){
				if(rstCheck.getString(1).equals(userid)){
					isSame = true;
				}
			}
	
	
			if(isSame == true){
				out.println("Account with that userID already exists.");
				closeConnection();
			}else{
				String sql = "INSERT INTO customer"
							+ " VALUES ( ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? )";
	
				PreparedStatement pstmt = con.prepareStatement(sql);
				pstmt.setString(1, firstName);
				pstmt.setString(2, lastName);
				pstmt.setString(3, email);
				pstmt.setString(4, phonenum);
				pstmt.setString(5, address);
				pstmt.setString(6, city);
				pstmt.setString(7, state);
				pstmt.setString(8, postalCode);
				pstmt.setString(9, country);
				pstmt.setString(10, userid);
				pstmt.setString(11, password);
	
				pstmt.executeUpdate();
	
				// Make sure to close connection
				response.sendRedirect("login.jsp");
				closeConnection();
				}
			}
		}
	
		
	
	
	
	%>




</body>
</html>


