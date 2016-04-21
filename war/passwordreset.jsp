<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>

	<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="css/passwordreset.css">
	
	<script src='https://code.jquery.com/jquery-1.11.3.min.js'></script>
	<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js'></script>
	<script src="//use.edgefonts.net/just-another-hand;londrina-sketch.js"></script>
	<script src='js/passwordreset.js'></script>

</head>

	<body>
	<%
	String number = request.getParameter("number");
	String email = request.getParameter("email");
	if(number != null && email != null){
		session.setAttribute("number", number);
		session.setAttribute("email", email);
	}
	else{
		session.setAttribute("number", "");
		session.setAttribute("email", "");
	}
	%>
	<div id="panel" class="container col-sm-offset-3 col-sm-6 col-sm-offset-3">
		<div id="title">
			<h1 id="title">Study Buddy</h1>
			<h1 id="subtitle">Find your buddy.</h1>
		</div>
	
			<form id='passwordReset' method='post' action='/passwordReset'>
				<hr>
				<h3>Password Reset</h3>
				<div id="student-passwords-dont-match"></div>
				<div class='form-group'>
					New Password
					<input type='password' id='studentPassword1' name='password' class='form-control' required>
				</div>
				<div class='form-group'>
					Repeat New Password
					<input type='password' id='studentPassword2' name='password2' class='form-control' required>
				</div>
				<br>
				<button type='button' class='btn btn-block btn-primary' id='passwordResetSubmit' style="width: 30%; margin-bottom: 30px;">Submit</button>
			</form>
		</div>

	</body>
</html>