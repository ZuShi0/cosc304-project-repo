<%
	// Remove the user from the session to log them out
	session.setAttribute("authenticatedUser",null);
	response.sendRedirect("shop.jsp");		// Re-direct to main page
%>

