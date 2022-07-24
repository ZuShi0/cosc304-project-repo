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
<title>Limit DNE - Review Page</title>
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
<%
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
} 

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

// Make connection
try (Connection con = DriverManager.getConnection(url, uid, pw);)
{
    long millis = System.currentTimeMillis();
	java.sql.Date date = new java.sql.Date(millis);
    String reviewDate = date.toString();
    String reviewComment = request.getParameter("reviewComment");
    String reviewRating = request.getParameter("reviewRating");
    String customerId = request.getParameter("customerId");
    String productId = request.getParameter("productId");
    String redirStr = "product.jsp?id="+productId;

    String checkReview = "SELECT customerId, productId FROM review WHERE customerId = ? AND productId = ?";
    PreparedStatement pstmtVal = con.prepareStatement(checkReview);
    pstmtVal.setString(1, customerId);
    pstmtVal.setString(2, productId);
    ResultSet rst = pstmtVal.executeQuery();

    if (!rst.isBeforeFirst()){
    String sql = "INSERT INTO review (reviewRating, "
    +"reviewDate, customerId, productId, reviewComment) "
    +"VALUES (?,?,?,?,?)";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, reviewRating);
    pstmt.setString(2, reviewDate);
    pstmt.setString(3, customerId);
    pstmt.setString(4, productId);
    pstmt.setString(5, reviewComment);
    pstmt.executeUpdate();

    out.print("<h2>Thanks for leaving a review!</h2>");
    response.sendRedirect(redirStr);
    }
    else{
    response.sendRedirect(redirStr);
    }
}

catch (SQLException ex) { 	
	out.println(ex); 
}


%>
</BODY>
</HTML>