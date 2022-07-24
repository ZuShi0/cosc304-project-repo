<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	// No products currently in list.  Create a list.
	productList = new HashMap<String, ArrayList<Object>>();
}
Integer quantity = new Integer(1);
if (request.getParameter("newQ") != "" && request.getParameter("newQ") != null && request.getParameter("newQId") != null && request.getParameter("newQId") != ""){
	quantity = Integer.valueOf(request.getParameter("newQ"));
	String newQId = request.getParameter("newQId");
	ArrayList<Object> qty = new ArrayList<Object>();
	qty = (ArrayList<Object>) productList.get(newQId);
	qty.set(3, new Integer(quantity));
}
else{
// Add new product selected
// Get product information
String id = request.getParameter("id");
String name = request.getParameter("name");
String price = request.getParameter("price");
String imgUrl = request.getParameter("imgLink");

// Store product information in an ArrayList
ArrayList<Object> product = new ArrayList<Object>();
product.add(id);
product.add(name);
product.add(price);
product.add(quantity);
product.add(imgUrl);

// Update quantity if add same item to order again
if (productList.containsKey(id))
{	product = (ArrayList<Object>) productList.get(id);
	int curAmount = ((Integer) product.get(3)).intValue();
	product.set(3, new Integer(curAmount+1));
}
else
	productList.put(id,product);
}
session.setAttribute("productList", productList);
%>
<jsp:forward page="showcart.jsp" />