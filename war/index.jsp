<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="studybuddy.Tutor" %>
<%@ page import="studybuddy.Student" %>
<%@ page import="studybuddy.Person" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="javax.servlet.ServletContext" %>
<%@ page import="javax.servlet.RequestDispatcher" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>

	<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="css/landingpage.css">
	
	<script src='https://code.jquery.com/jquery-1.11.3.min.js'></script>
	<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js'></script>
	<script src="//use.edgefonts.net/just-another-hand;londrina-sketch.js"></script>
	<script src='js/landingpage.js'></script>
	
</head>

<body>
	<%
		String error = request.getParameter("page");
	%>
	<div id="panel" class="container col-sm-offset-3 col-sm-6 col-sm-offset-3">
		<div id="title">
			<h1 id="title">Study Buddy</h1>
			<h1 id="subtitle">Find your buddy.</h1>
			
		</div>
		<%
			if(error != null && error.equals("loginError"))
				pageContext.setAttribute("msg", "Either the email or the password that you have entered was not found. Please try again.");
			else if(error != null && error.equals("signupError"))
				pageContext.setAttribute("msg", "The email that you entered is already used for an account. Please try again.");
			else{}
		%>
		<font color="red"> ${fn:escapeXml(msg)} </font>
		<div id="forms">
			<form id='login' method='post' action='/login'>
				<h3>Log In</h3>
				<div class="form-group">
					Email
					<input id="loginEmail" name="email" type="email" class='form-control' required>
				</div>
				<div class="form=group">
					Password
					<input id="loginPassword" name="password" type="password" class='form-control' required>
				</div>
				<br>
				<input type='submit' class='btn btn-block btn-primary' id='loginSubmit' value='Submit'>
			</form>
			<form id="forgotPasswordForm" method="post" action="/forgotPassword">
				<h3>Send a Password Reminder Email</h3>
				Email
				<input id="forgotPasswordEmail" name="email" type="email" class='form-control' required>
				<br>
				<input type='submit' class='btn btn-block btn-primary' id='forgotPasswordSubmit' value='Submit'>
			</form>
			<form id='studentSignUp' method='post' action='/studentSignUp'>
				<hr>
				<h3>Sign Up as a Student</h3>
				<div class='form-group'>
					First Name 
					<input type='text' id='studentFirstName' name='firstName' class='form-control'required>
				</div>
				<div class='form-group'>
					Last Name 
					<input type='text' id='studentLastName' name='lastName' class='form-control'required>
				</div>
				<div class='form-group'>
					Email 
					<input type='email' id='studentEmail' name='email' class='form-control' required>
				</div>
				<div id="student-passwords-dont-match"></div>
				<div class='form-group'>
					Password
					<input type='password' id='studentPassword1' name='password' class='form-control' required>
				</div>
				<div class='form-group'>
					Repeat Password
					<input type='password' id='studentPassword2' name='password2' class='form-control' required>
				</div>
				<br>
				<button type='button' class='btn btn-block btn-primary' id='studentSignUpSubmit'>Submit</button>
			</form>
			<form id='tutorSignUp' method='post' action='/tutorSignUp'>
				<hr>
				<h3>Sign Up as a Tutor</h3>
				<div class='form-group'>
					First Name 
					<input type='text' id='tutorFirstName' name='firstName' class='form-control' required>
				</div>
				<div class='form-group'>
					Last Name 
					<input type='text' id='tutorLastName' name='lastName' class='form-control' required>
				</div>
				<div class='form-group'>
					Email 
					<input type='email' id='tutorEmail' name='email' class='form-control' required>
				</div>
				<div class='form-group'>
					Hourly Rate
					<input type='number' min='0' id='tutorRate' name='price' class='form-control' required>
				</div>
				<div class='form-group'>
					Limits
					<input type='number' min='0' id='tutorLimit' name='limit' class='form-control' required>
				</div>
				<div id="tutor-passwords-dont-match"></div>
				<div class='form-group'>
					Password
					<input type='password' id='tutorPassword1' name='password' class='form-control' required>
				</div>
				<div class='form-group'>
					Repeat Password
					<input type='password' id='tutorPassword2' name='password2' class='form-control' required>
				</div>
				<br>
				<button type='button' class='btn btn-block btn-primary' id='tutorSignUpSubmit'>Submit</button>
			</form>
		</div>
		<button class= 'btn btn-link' id='forgotPassword'>Forgot Password?</button>
		<div id="signup-buttons">
			<button class= 'btn btn-default' id='showStudent'>Sign Up as Student</button>
			<button class= 'btn btn-default' id='showTutor'>Sign Up as Tutor</button>
			<button class= 'btn btn-default' id='showLogin'>Log In with Existing Account</button>
		</div>
	</div>
</body>
</html>