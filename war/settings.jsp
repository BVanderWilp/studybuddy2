<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="studybuddy.Tutor" %>
<%@ page import="studybuddy.Student" %>
<%@ page import="studybuddy.Person" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
Cookie[] cookies = request.getCookies();

if (cookies.length == 0) {
	response.sendRedirect("/index.jsp");
}

String email = null;

for(Cookie cookie : cookies){
    if("email".equals(cookie.getName())){
        email = cookie.getValue();
    }
}

if (email == null) {
	response.sendRedirect("/index.jsp");
}

Person user = null;
ObjectifyService.register(Student.class);
ObjectifyService.register(Tutor.class);
List<Student> students = ObjectifyService.ofy().load().type(Student.class).list();
List<Tutor> tutors = ObjectifyService.ofy().load().type(Tutor.class).list();
boolean found = false;
Person p = null;
for (int i = 0; i < students.size(); i++) {
	p = students.get(i);
	if (p.getEmail().equals(email)) {
		found = true;
		user = p;
		break;
	}
}
if (!found) {
	for (int i = 0; i < tutors.size(); i++) {
		p = tutors.get(i);
		if (p.getEmail().equals(email)) {
			found = true;
			user = p;
			break;
		}
	}
}
if (!found) {
	response.sendRedirect("/index.jsp");
}
pageContext.setAttribute("first_name", user.getFirstName());
pageContext.setAttribute("last_name", user.getLastName());
pageContext.setAttribute("email", user.getEmail());
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Study Buddy - Settings</title>

    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    
    <link href="css/settings.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="css/sb-admin.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

    <div id="wrapper">

        <!-- Navigation -->
        <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="dashboard.jsp">Study Buddy</a>
            </div>
            <!-- Top Menu Items -->
            <ul class="nav navbar-right top-nav">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user"></i> ${fn:escapeXml(first_name)} ${fn:escapeXml(last_name)} <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                        <li>
                            <a href="settings.jsp"><i class="fa fa-fw fa-gear"></i> Settings</a>
                        </li>
                        <li class="divider"></li>
                        <li>
                        	<form id="logoutForm" method="post" action="/logout">
                        		<a id="logoutButton"><i class="fa fa-fw fa-power-off"></i> Log Out</a>
                        	</form>
                        </li>
                    </ul>
                </li>
            </ul>
            <!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
            <div class="collapse navbar-collapse navbar-ex1-collapse">
                <ul class="nav navbar-nav side-nav">
                    <li>
                        <a href="dashboard.jsp"><i class="fa fa-fw fa-dashboard"></i> Dashboard</a>
                    </li>
                    <li>
                        <a href="matches.jsp"><i class="fa fa-fw fa-group"></i> 
                        <%
                        if (user.getIsTutor()) {
                        %> 
                        Student Matches</a>
                        <%
                        }
                        else {
                        %>
                        Tutor Matches</a>
                        <%
                        }
                        %>
                    </li>
                    <li>
                        <a href="settings.jsp"><i class="fa fa-fw fa-gear"></i> Settings</a>
                    </li>
<!--
                    <li>
                        <a href="javascript:;" data-toggle="collapse" data-target="#demo"><i class="fa fa-fw fa-arrows-v"></i> Dropdown <i class="fa fa-fw fa-caret-down"></i></a>
                        <ul id="demo" class="collapse">
                            <li>
                                <a href="#">Dropdown Item</a>
                            </li>
                            <li>
                                <a href="#">Dropdown Item</a>
                            </li>
                        </ul>
                    </li>
-->
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </nav>

        <div id="page-wrapper">

            <div class="container-fluid">

                <div class="row">
                	<h1>Change Profile Information</h1>
                </div>
               	<form id="form" method="post" action="/saveProfileInformation">
               		<div class="row">
	                	<div class="col-lg-offset-1 col-lg-4 col-lg-offset-2">
	                		First Name*
	                		<input id="first-name" name="first-name" class="form-control" type="text" value="${fn:escapeXml(first_name)}" required>
	                	</div>
	                	<div class="col-lg-4 col-lg-offset 1">
	                		Last Name*
	                		<input id="last-name" name="last-name" class="form-control" type="text" value="${fn:escapeXml(last_name)}" required>
	                	</div>
                	</div>
					<input class="hidden" name="email" value="${fn:escapeXml(email)}">
                	<div class="row">
                		<div class="col-lg-offset-1 col-lg-10 col-lg-offset-1 form-div">
                			<h4>Change Password</h4>
                			<div id="passwords-dont-match"></div>
                		</div>
                	</div>
                	<div class="row">
                		<div class="col-lg-offset-1 col-lg-10 col-lg-offset-1 form-div">
	                		New Password
	                		<input id="password" name="password" class="form-control" type="password">
	                	</div>
                	</div>
                	<div class="row">
                		<div class="col-lg-offset-1 col-lg-10 col-lg-offset-1 form-div">
	                		Retype New Password
	                		<input id="password2" class="form-control" type="password">
	                	</div>
                	</div>
                	<br>
                	<div class="row">
                		<div class="col-lg-offset=1 col-lg-10 col-lg-offset-1 form-submit">
                			<button type='button' class='btn btn-block btn-primary' id='submit-button'>Save</button>
                		</div>
                	</div>
               	</form>
               	<br>
               	<hr>
               	
               	<div class="row">
               		<h1>Add and Remove Subjects</h1>
               	</div>
               	<br>
               	<div class="row">
               		<form method="post" action="/addSubject">
               			<div class="col-sm-offset-1 col-sm-10 col-sm-offset-1">
               				Add a Subject (ex. EE 461L)
               				<input name="subject">
               				<input class="btn btn-primary" type="submit" value="Add Subject">
               			</div>
               		</form>
               	</div>
               	<div class="row">
               		<br>
               		<div class="col-sm-offset-1 col-sm-10 col-sm-offset-1">
	               		<h4>My Subjects</h4>
	               		<table class="table table-hover">
	               			<tr>
	               				<th>Subject</th>
	               				<th>Remove Subject</th>
	               			</tr>
	               			<%
	               			ArrayList<String> subjects = user.getSubjects();
	               			for (int i = 0; i < subjects.size(); i++) {
	               			%>
	               			<tr>
	               				<td>
	               				<%
	               				String subject = subjects.get(i);
	               				for (int j = 0; j < subject.length(); j++) {
	               					if (Character.isDigit(subject.charAt(j))) {
	               						subject = subject.substring(0, j) + " " + subject.substring(j, subject.length());
	               						break;
	               					}
	               				}
	               				out.print(subject.toUpperCase());
	               				%>
	               				</td>
	               				<td>
	               					<form method="post" action="/removeSubject">
	               						<input name="email" class="hidden" value="<% out.print(user.getEmail()); %>">
	               						<input name="subject" class="hidden" value="<% out.print(subjects.get(i)); %>">
	               						<input type="submit" class="btn btn-danger" value="Remove">
	               					</form>
	               				</td>
	               			</tr>
	               			<%
	               			}
	               			%>
	               		</table>
	               	</div>
               	</div>

            </div>
            <!-- /.container-fluid -->

        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js"></script>
    
    <script src="js/settings.js"></script>

</body>

</html>
