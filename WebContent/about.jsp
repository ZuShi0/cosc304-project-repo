<!DOCTYPE html>
<html>
<head>
        <title>Limit DNE - About Page</title>
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

    p.words {
        border: 3px solid black;
        margin: auto;
        max-width: fit-content;
        text-align: center;
    }

    div.fancy {
        border: 3px solid black;
        margin: auto;
        max-width: max-content;
        padding: 50px;
        box-shadow:
        inset 0 0 50px #fff,     
        inset 20px 0 80px #f0f,   
        inset -20px 0 80px #0ff,  
        inset 20px 0 300px #f0f,  
        inset -20px 0 300px #0ff, 
        0 0 50px #fff,           
        -10px 0 80px #f0f,       
        10px 0 80px #0ff;
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
<div class="fancy">
<h1 align="center">Our Company</h1>
<p align="center"><b>Limit DNE Corporation Limited</b></p>
<p align="center"><a href="shop.jsp"><img src="img/logo.jpg"></a></p>
<h2 align="center">Our Purpose</h2>
<p class="words">We at Limit DNE sell out of stock 
	and hard to find goods with the purpose of enhancing human well being, 
	and human development throughout our universe. Life on this planet is very rudimentary, 
	we need change! We must bring upon change!</p>
<h2 align="center">Our Promise to You</h2>
<p class="words">On a daily basis, scalpers utilize bots to purchase tech, clothing, and limited time goods much faster
    than any normal consumer can. These scalped goods are then sold at massively marked up prices, which ruins the
    consumer experience, and causes problematic fluctuations in supply and demand. What Limit DNE will provide is a
    space for regular consumers to purchase these rare goods at a reasonable price. Finally, this will ensure that all
    consumers can get what they want exactly when they want it without having to pay an arm and a leg. Limit DNE is a
    company created by consumers, for consumers. The well-being and happiness of humans on earth and across the galaxy
    rests on our shoulders, which happens to be the most reliable set of shoulders in the galaxy. </p>
</div>

</body>
</head>