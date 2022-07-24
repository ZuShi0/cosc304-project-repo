<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Limit DNE - Warehouse Info</title>
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
		<li><a class="active" href="displaywares.jsp">Warehouse Info</a></li>
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
<h1>Warehouse Inventory</h1>

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
    String edited = "false";
    if (request.getParameter("edited") != null){
    if (request.getParameter("edited").equals("true")){
        edited = request.getParameter("edited");
        String wareId = request.getParameter("wareId");
        String upSQL1 = "SELECT productId FROM productinventory WHERE warehouseId = ?";
        PreparedStatement upPst = con.prepareStatement(upSQL1);
        upPst.setString(1, wareId);
        ResultSet upRst1 = upPst.executeQuery();
        String upSQL2 = "UPDATE productinventory SET quantity=? WHERE productId=?";
        PreparedStatement upPst2 = con.prepareStatement(upSQL2);
        while(upRst1.next()){
            String upPid = upRst1.getString(1);
            upPst2.setString(2, upPid);
            String upqty = request.getParameter(upPid);
            upPst2.setString(1, upqty);
            upPst2.executeUpdate();
        }

    }
}
    boolean editing = false;
    String wareSQL = "SELECT * FROM warehouse ORDER BY warehouseId ASC";	
    if (!(request.getParameter("editId") == "" || request.getParameter("editId") == null)){
        out.println("<table><th>Current Inventory</th>");
        editing = true;
        String editId = request.getParameter("editId");
        wareSQL = "SELECT * FROM warehouse WHERE warehouseId = "+editId;
    }
    ResultSet wareRst = stmt.executeQuery(wareSQL);
	out.println("<table>"
					+"<tr>"
						+"<th>Warehouse Id</th>"
						+"<th>Warehouse Name</th>"
                        +"<th></th>"
					+"</tr>");
	while (wareRst.next())
	{	
		out.println("<tr><td>"+wareRst.getInt(1)+"</td>");
		out.println("<td>"+wareRst.getString(2)+"</td>");
        out.println("<td><form method=\"get\" action=\"displaywares.jsp\">"
            +"<input type=\"hidden\" name=\"editId\" value=\""+wareRst.getString(1)+"\">"
            +"<input type=\"submit\" value=\"Edit\">"
            +"</form></td></tr>");

			String pSQL = "SELECT productId, quantity, price"
						+ " FROM productinventory"
						+ " WHERE warehouseId = ?";
			PreparedStatement pstmt = con.prepareStatement(pSQL);
			pstmt.setInt(1, wareRst.getInt(1));
			ResultSet prst = pstmt.executeQuery();

		out.println("<tr align=\"right\"><td colspan= \"3\"><table>");
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
    if (editing == true){
        out.println("</table>");
        String editSQL = "SELECT * FROM warehouse WHERE warehouseId=?";
        PreparedStatement editPstmt = con.prepareStatement(editSQL);
        editPstmt.setString(1, request.getParameter("editId"));
        ResultSet editRst = editPstmt.executeQuery();
        out.println("<table><th>New Inventory</th>");
            out.println("<table>"
                +"<tr>"
                    +"<th>Warehouse Id</th>"
                    +"<th>Warehouse Name</th>"
                    +"<th></th>"
                +"</tr>");
while (editRst.next())
{	
    out.println("<tr><td>"+editRst.getInt(1)+"</td>");
    out.println("<td>"+editRst.getString(2)+"</td>");
    out.println("<td><form method=\"get\" action=\"displaywares.jsp\">"
        +"<input type=\"submit\" value=\"Submit Changes\">"
        +"<input type=\"hidden\" name=\"wareId\" value=\""+editRst.getString(1)+"\">"
        +"<input type=\"hidden\" name=\"edited\" value=\"true\">"
        +"</td></tr>");

        String epSQL = "SELECT productId, quantity, price"
                    + " FROM productinventory"
                    + " WHERE warehouseId = ?";
        PreparedStatement epstmt = con.prepareStatement(epSQL);
        epstmt.setInt(1, editRst.getInt(1));
        ResultSet eprst = epstmt.executeQuery();

    out.println("<tr align=\"right\"><td colspan= \"3\"><table>");
    out.println("<tr>"
                    +"<th>Product Id</th>"
                    +"<th>Quantity</th>"
                    +"<th>Price</th>"
                +"</tr>");
            while (eprst.next())
            {
                out.println("<tr><td>"+ eprst.getInt(1) + "</td>");
                out.println("<td><input type=\"text\" size=\"30\" value=\""
                + eprst.getString(2) + "\" name=\""+eprst.getString(1)+"\"></td>");
                out.println("<td>"+ currFormat.format(eprst.getFloat(3)) + "</td></tr>");
            }
    out.println("</table></td></tr>");
}
out.println("</table></table>");
    }
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