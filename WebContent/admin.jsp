<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<!DOCTYPE html>
<html>
<head>
<title>Limit DNE - Admin Page</title>
</head>
<style>
	table, th, td {
		  border: 1px solid black;
		  border-collapse: collapse;
		padding: 0.2em;
	}
	#wrapper{
		margin-left: 25%;
		margin-right: 25%;
		width: auto;
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
				out.println("<li><a class=\"active\" href=\"admin.jsp\">Admin Portal</a></li>");
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
// TODO: Include files auth.jsp and jdbc.jsp
%>

<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp"%>


<br>
<br>

<div id="wrapper">

	<br>
	<br>

<%
getConnection();
// TODO: Write SQL query that prints out all cusotmers

String sqlCust = "SELECT customerId, userid, firstName, lastName, email"
            + " FROM customer";
PreparedStatement pstmt = con.prepareStatement(sqlCust);
ResultSet rstCust = pstmt.executeQuery();

out.println("<button onclick=\"showCust()\">List All Customers</button>");
out.println("<div id=\"showCustDIV\" style=\"display: none;\">");
out.println("<br>");

while (rstCust.next()) {
    out.println("<table>");
    String custId = rstCust.getString(1);
    String userId = rstCust.getString(2);
    String fName = rstCust.getString(3);
    String lName = rstCust.getString(4);
    String email = rstCust.getString(5);

    out.println("<tr><th>Customer Id</th><td>" + custId +"</td></tr>");
    out.println("<tr><th>User Id</th><td>" + userId +"</td></tr>");
    out.println("<tr><th>First Name</th><td>" + fName +"</td></tr>");
    out.println("<tr><th>Last Name</th><td>" + lName +"</td></tr>");
    out.println("<tr><th>Email</th><td>" + email +"</td></tr>");
    out.println("</table> <br> <br>");

}

out.println("</div>");


// TODO: Write SQL query that prints out total order amount by day
String sqlAmount = "SELECT CAST(orderDate as date), SUM(totalAmount), orderId"
                + " FROM ordersummary"
                + " GROUP BY CAST(orderDate as date), orderId";
pstmt = con.prepareStatement(sqlAmount);
ResultSet rstAmount = pstmt.executeQuery();

out.println("<button onclick=\"showOrders()\">Show All Orders</button>");
out.println("<div id=\"showOrdersDIV\" style=\"display: none;\"><br>");
out.println("<table><tr><th>Order Date</th><th>Total Order Amount</th><th></th></tr>");

while (rstAmount.next()) {

    String date = rstAmount.getString(1);
    String sum = rstAmount.getString(2);
	String orderId = rstAmount.getString(3);

    out.println("<tr><td>" + date + "</td><td>" + sum 
		+"</td><td><form method=\"get\" action=\"ship.jsp\">"
		+"<input type=\"hidden\" name=\"orderId\" value=\""+orderId+"\">"
		+"<input type=\"submit\" value=\"Ship Order\">"
		+"</form></td></tr>");

}

out.println("</table>");
out.println("</div>");

%>

<button onclick="insertProduct()">Insert Product</button>
<div id="showInsertProduct" style="display: none;">
<br>

<form method="post" action="insertprod.jsp">
Product Name:
<input type="text" name="productName"> <br>
Price
<input type="text" name="productPrice"> <br>
Img Url
<input type="url" name="productImageUrl"> <br>
Product Description
<input type="text" name="productDesc"> <br>
Category
<select name="categoryName">
	<option value="1">Consoles 1</option>
	<option value="2">Clothing 2</option>
	<option value="3">PC Hardware 3</option>
	<option value="4">Groceries 4</option>
</select> <br>
<input type="submit" value="Submit"><input type="reset" value="Reset">
</form>
</div>

<button onclick="updateProduct()">Update/Delete Product</button>
<div id="showUpdateProduct" style="display: none;">
<br>

<%

NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

String SQL = "SELECT productName, productPrice, productId, categoryName "
				+"FROM product join category ON product.categoryId = category.categoryId ";
	pstmt = con.prepareStatement(SQL);

	ResultSet rst = pstmt.executeQuery();

	out.println("<table>"
		+"<tr>"
			+"<th></th>"
            +"<th></th>"
			+"<th>Product Name</th>"
			+"<th>Category</th>"
			+"<th>Price</th>"
		+"</tr>");
	while (rst.next()) {
		//String addLink = "addcart.jsp?id=" + rst.getInt(3) + "&name="
		//				+""+ rst.getString(1) + "&price=" + rst.getFloat(2);
		String upProdLink = "updateProd.jsp?id=" + rst.getInt(3);
		String delProdLink = "deleteprod.jsp?id=" + rst.getInt(3);
		String detailLink = "product.jsp?id=" + rst.getInt(3);
		out.println("<tr><td><a href=" + "\"" + upProdLink + "\"" +"><button type=\"button\" class=\"update\">Update</button></a></td>");
        out.println("<td><a href=" + "\"" + delProdLink + "\"" +"><button type=\"button\" class=\"delete\">Delete</button></a></td>");
		out.println("<td><a href=" + "\"" + detailLink + "\"" +">"+rst.getString(1)+"</a></td>");
		out.println("<td>"+rst.getString(4)+"</td>");
		out.println("<td>"+currFormat.format(rst.getFloat(2))+"</td></tr>");
	}
	out.println("</table>");
    out.println("</div>");

%>


<script>
    function showCust() {
      var x = document.getElementById("showCustDIV");
      if (x.style.display === "none") {
        x.style.display = "block";
      } else {
        x.style.display = "none";
      }
    }

    function showOrders() {
      var x = document.getElementById("showOrdersDIV");
      if (x.style.display === "none") {
        x.style.display = "block";
      } else {
        x.style.display = "none";
      }
    }

    function insertProduct() {
      var x = document.getElementById("showInsertProduct");
      if (x.style.display === "none") {
        x.style.display = "block";
      } else {
        x.style.display = "none";
      }
    }

    function updateProduct() {
      var x = document.getElementById("showUpdateProduct");
      if (x.style.display === "none") {
        x.style.display = "block";
      } else {
        x.style.display = "none";
      }
    }
</script>

</div>

<%
closeConnection();
%>

</body>
</html>

